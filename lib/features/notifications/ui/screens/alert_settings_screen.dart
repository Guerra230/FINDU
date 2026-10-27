import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';

class AlertSettingsScreen extends StatefulWidget {
  const AlertSettingsScreen({super.key});

  @override
  State<AlertSettingsScreen> createState() => _AlertSettingsScreenState();
}

class _AlertSettingsScreenState extends State<AlertSettingsScreen> {
  final _values = <String, bool>{
    'Mascotas perdidas cerca de mí': true,
    'Objetos en mis comunidades': true,
    'Avistamientos de mis publicaciones': true,
    'Mensajes del chat': true,
    'Recompensas y pagos': true,
    'Novedades de FINDU': false,
  };
  int _radius = 1;

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Configurar alertas'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                Text('Elige qué avisos quieres recibir', style: FdTypography.caption),
                const SizedBox(height: FdSpacing.sm),
                FdGlass(
                  strong: true,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final entry in _values.entries)
                        FdToggleRow(
                          label: entry.key,
                          value: entry.value,
                          onChanged: (v) => setState(() => _values[entry.key] = v),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                Text('Radio de alertas', style: FdTypography.h2),
                const SizedBox(height: FdSpacing.xs),
                Wrap(
                  spacing: FdSpacing.xs,
                  children: [
                    for (final km in const [1, 3, 5])
                      FdChip(label: '$km km', selected: _radius == km, onTap: () => setState(() => _radius = km)),
                  ],
                ),
                const SizedBox(height: FdSpacing.lg),
                FdListRow(
                  leading: const Icon(Icons.location_on_outlined, color: FdColors.primary),
                  title: 'Valle del Lili, Cali',
                  subtitle: 'Ubicación base',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('En el Sprint 2 se toma tu ubicación real')),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: 'Guardar',
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                messenger.showSnackBar(const SnackBar(content: Text('Alertas guardadas')));
              },
            ),
          ),
        ],
      ),
    );
  }
}
