import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String _code = DemoData.accessCode;
  int _uses = 3;
  final _requests = <String>['Andrés M.', 'Valentina P.'];

  void _newCode() {
    final number = 1000 + Random().nextInt(9000);
    setState(() {
      _code = 'LILI-$number';
      _uses = 0;
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código copiado')));
  }

  void _resolve(String name, bool accepted) {
    setState(() => _requests.remove(name));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(accepted ? '$name ya es miembro' : 'Rechazaste la solicitud de $name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final community = DemoData.communities.firstWhere((c) => c.isAdmin);

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Panel de administración'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                Text('${community.name} · ${community.members} miembros · Eres admin', style: FdTypography.caption),
                const SizedBox(height: FdSpacing.md),
                FdGlass(
                  strong: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Código de acceso', style: FdTypography.bodyStrong),
                      const SizedBox(height: FdSpacing.xs),
                      Text(_code, style: FdTypography.display.copyWith(color: FdColors.primary)),
                      Text('$_uses de 20 usos · vence el 30 de noviembre', style: FdTypography.caption),
                      const SizedBox(height: FdSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: FdButton(
                              label: 'Copiar',
                              icon: Icons.copy_rounded,
                              variant: FdButtonVariant.secondary,
                              onPressed: _copy,
                            ),
                          ),
                          const SizedBox(width: FdSpacing.sm),
                          Expanded(
                            child: FdButton(
                              label: 'Generar nuevo',
                              variant: FdButtonVariant.secondary,
                              onPressed: _newCode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                Text('Solicitudes pendientes (${_requests.length})', style: FdTypography.h2),
                const SizedBox(height: FdSpacing.sm),
                if (_requests.isEmpty)
                  const FdEmptyState(
                    mood: FdMood.feliz,
                    title: 'Sin solicitudes',
                    message: 'Cuando alguien pida unirse sin código, aparecerá aquí.',
                  )
                else
                  for (final name in _requests)
                    Padding(
                      padding: const EdgeInsets.only(bottom: FdSpacing.sm),
                      child: FdGlass(
                        strong: true,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                FdAvatar(name: name),
                                const SizedBox(width: FdSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: FdTypography.bodyStrong),
                                      Text('Solicitó unirse sin código', style: FdTypography.caption),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: FdSpacing.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: FdButton(
                                    label: 'Rechazar',
                                    variant: FdButtonVariant.danger,
                                    onPressed: () => _resolve(name, false),
                                  ),
                                ),
                                const SizedBox(width: FdSpacing.sm),
                                Expanded(
                                  child: FdButton(
                                    label: 'Aceptar',
                                    variant: FdButtonVariant.secondary,
                                    icon: Icons.check_rounded,
                                    onPressed: () => _resolve(name, true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: FdSpacing.sm),
                const FdInfoNote(message: 'Solo los administradores pueden aceptar miembros y crear códigos de acceso.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
