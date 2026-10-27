import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/widgets/publish_parts.dart';

class PublishObjectScreen extends StatefulWidget {
  const PublishObjectScreen({super.key});

  @override
  State<PublishObjectScreen> createState() => _PublishObjectScreenState();
}

class _PublishObjectScreenState extends State<PublishObjectScreen> {
  bool _lost = true;
  int _photos = 0;
  String? _category;
  String? _place;
  String _reward = '\$0';
  final _description = TextEditingController();
  final _questions = [
    TextEditingController(text: '¿Qué marca es?'),
    TextEditingController(text: '¿Qué tiene grabado o pegado?'),
    TextEditingController(),
  ];

  static const _categories = ['Celular', 'Mochila', 'Billetera', 'Llaves', 'Audífonos', 'Otro'];
  static const _places = ['Biblioteca', 'Cafetería', 'Edificio A', 'Edificio L', 'Bienestar', 'Coliseo'];
  static const _rewards = ['\$0', '\$20.000', '\$50.000', 'Otro'];

  @override
  void dispose() {
    _description.dispose();
    for (final c in _questions) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _valid {
    final base = _photos > 0 && _description.text.trim().isNotEmpty && _category != null && _place != null;
    if (_lost) return base;
    return base && _questions.every((q) => q.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(
            title: 'Publicar objeto',
            trailing: FdIconButton(
              icon: Icons.pets_rounded,
              tooltip: 'Cambiar a mascota',
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.publishPet),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                FdSegmented<bool>(
                  options: const {true: 'Lo perdí', false: 'Lo encontré'},
                  selected: _lost,
                  onChanged: (v) => setState(() => _lost = v),
                ),
                const SizedBox(height: FdSpacing.md),
                PhotoPicker(count: _photos, onAdd: () => setState(() => _photos++)),
                const SizedBox(height: FdSpacing.md),
                FdTextField(
                  label: 'Descripción pública',
                  hint: _lost ? 'Audífonos blancos en estuche' : 'Qué encontraste, sin detalles privados',
                  controller: _description,
                  onChanged: (_) => setState(() {}),
                ),
                PublishSection(
                  title: 'Categoría',
                  child: ChoiceWrap(options: _categories, selected: _category, onChanged: (v) => setState(() => _category = v)),
                ),
                PublishSection(
                  title: _lost ? 'Lugar donde lo perdiste' : 'Lugar donde lo encontraste',
                  child: ChoiceWrap(options: _places, selected: _place, onChanged: (v) => setState(() => _place = v)),
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
              arguments: _lost ? PublishKinds.objectLost : PublishKinds.objectFound,
            ),
          ),
        ],
      ),
    );
  }
}
