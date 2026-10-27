import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';

class ChooseUniversityScreen extends StatefulWidget {
  const ChooseUniversityScreen({super.key});

  @override
  State<ChooseUniversityScreen> createState() => _ChooseUniversityScreenState();
}

class _ChooseUniversityScreenState extends State<ChooseUniversityScreen> {
  String _query = '';
  String? _selected = DemoData.universities.first;

  @override
  Widget build(BuildContext context) {
    final results = DemoData.universities
        .where((u) => u.toLowerCase().contains(_query.trim().toLowerCase()))
        .toList();

    return AuthLayout(
      headerTitle: 'Crear cuenta',
      bottom: FdButton(
        label: 'Continuar',
        onPressed: _selected == null
            ? null
            : () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Elige tu universidad', style: FdTypography.h1),
                  const SizedBox(height: FdSpacing.xs),
                  Text(
                    'FINDU funciona en varias universidades. Tu correo institucional debe ser de la que elijas.',
                    style: FdTypography.caption,
                  ),
                ],
              ),
            ),
            const FdMascot(mood: FdMood.buscando, size: 72),
          ],
        ),
        const SizedBox(height: FdSpacing.lg),
        FdTextField(
          label: 'Buscar universidad',
          hint: 'Escribe el nombre',
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: FdSpacing.md),
        if (results.isEmpty)
          const FdEmptyState(
            title: 'No la encontramos',
            message: 'Revisa el nombre o solicita que la agreguemos.',
          )
        else
          FdOptionCards<String>(
            options: [
              for (final u in results) FdOption(value: u, title: u, subtitle: 'Cali'),
            ],
            selected: _selected,
            onChanged: (v) => setState(() => _selected = v),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recibimos tu solicitud. Te avisaremos cuando esté.')),
            ),
            child: Text(
              '¿No está tu universidad? Solicita agregarla',
              style: FdTypography.bodyStrong.copyWith(color: FdColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
