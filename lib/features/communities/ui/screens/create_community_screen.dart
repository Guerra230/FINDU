import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  String? _type;
  bool _evidence = false;

  static const _types = ['Educativa', 'Residencial', 'Corporativa', 'Pública', 'Evento temporal'];

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  bool get _valid => _name.text.trim().isNotEmpty && _type != null && _address.text.trim().isNotEmpty && _evidence;

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Crear comunidad'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                FdTextField(
                  label: 'Nombre de la comunidad',
                  hint: 'Ciudad Pacífica',
                  controller: _name,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: FdSpacing.md),
                FdGlass(
                  strong: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipo de comunidad', style: FdTypography.bodyStrong),
                      const SizedBox(height: FdSpacing.sm),
                      Wrap(
                        spacing: FdSpacing.xs,
                        runSpacing: FdSpacing.xs,
                        children: [
                          for (final t in _types) FdChip(label: t, selected: _type == t, onTap: () => setState(() => _type = t)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.md),
                FdTextField(
                  label: 'Ubicación (dirección)',
                  hint: 'Calle 18 # 122-135, Cali',
                  controller: _address,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: FdSpacing.md),
                FdListRow(
                  leading: Icon(_evidence ? Icons.check_circle_rounded : Icons.attach_file_rounded, color: FdColors.primary),
                  title: _evidence ? 'Evidencia adjunta' : 'Adjunta evidencia',
                  subtitle: 'Acta, NIT o dominio del correo',
                  onTap: () => setState(() => _evidence = !_evidence),
                ),
                const SizedBox(height: FdSpacing.md),
                const FdInfoNote(
                  message: 'Tu solicitud queda pendiente hasta que el equipo FINDU la apruebe. Tú quedarás como administrador.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: 'Enviar solicitud',
              onPressed: _valid
                  ? () => Navigator.pushReplacementNamed(context, AppRoutes.createSent, arguments: _name.text.trim())
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
