import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/ui/widgets/community_parts.dart';

class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({super.key});

  @override
  State<JoinCommunityScreen> createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  final _community = TextEditingController(text: 'Conjunto Bosques de Lili');
  final _code = TextEditingController();
  String _method = 'codigo';
  String? _codeError;

  @override
  void dispose() {
    _community.dispose();
    _code.dispose();
    super.dispose();
  }

  void _join() {
    if (_method == 'aprobacion') {
      Navigator.pushReplacementNamed(context, AppRoutes.joinPending, arguments: _community.text.trim());
      return;
    }
    if (_code.text.trim().toUpperCase() != DemoData.accessCode) {
      setState(() => _codeError = 'Código inválido o vencido. Pídeselo al admin.');
      return;
    }
    showFdBottomSheet<void>(
      context,
      builder: (sheetContext) => FdSheetContent(
        mood: FdMood.feliz,
        title: '¡Ya eres miembro!',
        message: 'Entraste a ${_community.text.trim()} con el código de acceso.',
        primaryLabel: 'Ver mis comunidades',
        onPrimary: () {
          Navigator.pop(sheetContext);
          goToCommunities(context);
        },
        cancelLabel: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _community.text.trim().isNotEmpty && (_method == 'aprobacion' || _code.text.trim().isNotEmpty);

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Unirse a una comunidad'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                FdTextField(label: 'Comunidad', controller: _community, onChanged: (_) => setState(() {})),
                const SizedBox(height: FdSpacing.lg),
                Text('Elige cómo verificarte', style: FdTypography.h2),
                const SizedBox(height: FdSpacing.sm),
                FdOptionCards<String>(
                  options: const [
                    FdOption(value: 'codigo', title: 'Código de acceso', subtitle: 'Te lo comparte el administrador de la comunidad'),
                    FdOption(value: 'aprobacion', title: 'Solicitar aprobación al admin', subtitle: 'El administrador revisa y acepta tu solicitud'),
                  ],
                  selected: _method,
                  onChanged: (v) => setState(() => _method = v),
                ),
                if (_method == 'codigo') ...[
                  FdTextField(
                    label: 'Código de acceso',
                    hint: 'Ej. LILI-4821',
                    controller: _code,
                    errorText: _codeError,
                    onChanged: (_) => setState(() => _codeError = null),
                  ),
                  const SizedBox(height: FdSpacing.md),
                ],
                const FdInfoNote(
                  message: 'Toda comunidad tiene un administrador. Entras con un código de acceso o cuando el admin aprueba tu solicitud. Puedes estar en varias comunidades.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: _method == 'codigo' ? 'Unirme' : 'Enviar solicitud',
              onPressed: ready ? _join : null,
            ),
          ),
        ],
      ),
    );
  }
}
