import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class DeliveryProblemScreen extends StatefulWidget {
  const DeliveryProblemScreen({super.key});

  @override
  State<DeliveryProblemScreen> createState() => _DeliveryProblemScreenState();
}

class _DeliveryProblemScreenState extends State<DeliveryProblemScreen> {
  String? _reason;
  final _detail = TextEditingController();

  static const _reasons = [
    FdOption(value: 'no_era', title: 'No era la mascota u objeto correcto'),
    FdOption(value: 'no_llego', title: 'La otra persona no llegó al encuentro'),
    FdOption(value: 'sin_acuerdo', title: 'No nos pusimos de acuerdo para vernos'),
    FdOption(value: 'otro', title: 'Otro motivo'),
  ];

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postId = routeId(context);

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Reportar problema'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                Text('¿Qué pasó con la entrega?', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Tu reporte no cierra la publicación. Elige el motivo:',
                  style: FdTypography.body.copyWith(color: FdColors.textSecondary),
                ),
                const SizedBox(height: FdSpacing.md),
                FdOptionCards<String>(
                  options: _reasons,
                  selected: _reason,
                  onChanged: (v) => setState(() => _reason = v),
                ),
                FdTextField(label: 'Cuéntanos qué pasó (opcional)', controller: _detail, maxLines: 3),
                const SizedBox(height: FdSpacing.md),
                const FdInfoNote(
                  message: 'La publicación vuelve a estar activa y la recompensa sigue retenida. El chat sigue abierto para acordar otro encuentro.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: 'Enviar reporte',
              onPressed: _reason == null
                  ? null
                  : () => Navigator.pushReplacementNamed(context, AppRoutes.problemSent, arguments: postId),
            ),
          ),
        ],
      ),
    );
  }
}
