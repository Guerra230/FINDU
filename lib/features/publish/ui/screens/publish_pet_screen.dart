import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/widgets/publish_parts.dart';

class PublishPetScreen extends StatefulWidget {
  const PublishPetScreen({super.key});

  @override
  State<PublishPetScreen> createState() => _PublishPetScreenState();
}

class _PublishPetScreenState extends State<PublishPetScreen> {
  bool _lost = true;
  int _photos = 0;
  String? _species;
  String? _neighborhood;
  String _reward = '\$0';
  final _name = TextEditingController();
  final _questions = [
    TextEditingController(text: '¿Qué color es su collar?'),
    TextEditingController(text: '¿Qué nombre tiene la placa?'),
    TextEditingController(),
  ];

  static const _speciesOptions = ['Perro', 'Gato', 'Otro'];
  static const _neighborhoods = ['Ciudad Jardín', 'Pance', 'Valle del Lili', 'El Ingenio', 'Cañas Gordas', 'Otro'];
  static const _rewards = ['\$0', '\$50.000', '\$100.000', 'Otro'];

  @override
  void dispose() {
    _name.dispose();
    for (final c in _questions) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _valid {
    final base = _photos > 0 && _species != null && _neighborhood != null;
    if (_lost) return base && _name.text.trim().isNotEmpty;
    return base && _questions.every((q) => q.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(
            title: 'Reportar mascota',
            trailing: FdIconButton(
              icon: Icons.inventory_2_outlined,
              tooltip: 'Cambiar a objeto',
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.publishObject),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                FdSegmented<bool>(
                  options: const {true: 'La perdí', false: 'La encontré'},
                  selected: _lost,
                  onChanged: (v) => setState(() => _lost = v),
                ),
                const SizedBox(height: FdSpacing.md),
                PhotoPicker(
                  count: _photos,
                  title: 'Sube una foto de la mascota',
                  hint: 'Una foto clara de frente',
                  onAdd: () => setState(() => _photos++),
                ),
                if (_lost) ...[
                  const SizedBox(height: FdSpacing.md),
                  FdTextField(
                    label: 'Nombre y raza',
                    hint: 'Canelita · Criolla café',
                    controller: _name,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
                PublishSection(
                  title: 'Especie',
                  child: ChoiceWrap(options: _speciesOptions, selected: _species, onChanged: (v) => setState(() => _species = v)),
                ),
                PublishSection(
                  title: _lost ? 'Barrio donde se perdió' : 'Barrio donde la encontraste',
                  child: ChoiceWrap(
                    options: _neighborhoods,
                    selected: _neighborhood,
                    onChanged: (v) => setState(() => _neighborhood = v),
                  ),
                ),
                if (_lost)
                  PublishSection(
                    title: 'Recompensa voluntaria',
                    subtitle: 'Se retiene y solo se libera cuando ambos confirman la entrega',
                    child: ChoiceWrap(options: _rewards, selected: _reward, onChanged: (v) => setState(() => _reward = v)),
                  )
                else
                  QuestionsEditor(controllers: _questions, onChanged: () => setState(() {})),
              ],
            ),
          ),
          PublishBottomBar(
            enabled: _valid,
            onPublish: () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.published,
              arguments: _lost ? PublishKinds.petLost : PublishKinds.petFound,
            ),
          ),
        ],
      ),
    );
  }
}
