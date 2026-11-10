import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/publish/ui/bloc/publish_cubit.dart';
import 'package:findu/features/publish/ui/widgets/publish_parts.dart';

class PublishPetScreen extends StatefulWidget {
  const PublishPetScreen({super.key});

  @override
  State<PublishPetScreen> createState() => _PublishPetScreenState();
}

class _PublishPetScreenState extends State<PublishPetScreen> {
  bool _lost = true;
  List<Uint8List> _photos = [];
  String? _species;
  String? _neighborhood;
  String _reward = '\$0';
  final _name = TextEditingController();
  final _breed = TextEditingController();
  final _questions = [
    QuestionFields(question: '¿Qué color es su collar?'),
    QuestionFields(question: '¿Qué nombre tiene la placa?'),
    QuestionFields(),
  ];

  static const _speciesOptions = ['Perro', 'Gato', 'Otro'];
  static const _neighborhoods = [
    'Ciudad Jardín',
    'Pance',
    'Valle del Lili',
    'El Ingenio',
    'Cañas Gordas',
    'Otro',
  ];
  static const _rewards = ['\$0', '\$50.000', '\$100.000'];

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  bool get _valid {
    final base =
        _photos.isNotEmpty && _species != null && _neighborhood != null;
    return _lost
        ? base && _name.text.trim().isNotEmpty
        : base && _questions.every((q) => q.complete);
  }

  void _publish(BuildContext context) {
    final name = _name.text.trim();
    context.read<PublishCubit>().publish(
      NewPost(
        kind: PostKind.pet,
        intent: _lost ? PostIntent.lost : PostIntent.found,
        title: _lost ? name : '$_species encontrado',
        category: _species!,
        place: _neighborhood!,
        photos: _photos,
        petName: _lost ? name : null,
        breed: _breed.text.trim().isEmpty ? null : _breed.text.trim(),
        reward: _lost ? parseCop(_reward) : null,
        questions: _lost ? const [] : _questions.map((q) => q.toNew()).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PublishScope(
      kind: () => _lost ? PublishKinds.petLost : PublishKinds.petFound,
      child: Builder(
        builder: (context) => FdScaffold(
          body: Column(
            children: [
              FdScreenHeader(
                title: 'Reportar mascota',
                trailing: FdIconButton(
                  icon: Icons.inventory_2_outlined,
                  tooltip: 'Cambiar a objeto',
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.publishObject,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.screen,
                    FdSpacing.xs,
                    FdSpacing.screen,
                    FdSpacing.lg,
                  ),
                  children: [
                    FdSegmented<bool>(
                      options: const {true: 'La perdí', false: 'La encontré'},
                      selected: _lost,
                      onChanged: (v) => setState(() => _lost = v),
                    ),
                    const SizedBox(height: FdSpacing.md),
                    PhotoPicker(
                      photos: _photos,
                      title: 'Sube una foto de la mascota',
                      hint: 'Una foto clara de frente',
                      onChanged: (v) => setState(() => _photos = v),
                    ),
                    if (_lost) ...[
                      const SizedBox(height: FdSpacing.md),
                      FdTextField(
                        label: 'Nombre',
                        hint: 'Canelita',
                        controller: _name,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                    const SizedBox(height: FdSpacing.sm),
                    FdTextField(
                      label: 'Raza (opcional)',
                      hint: 'Criolla café',
                      controller: _breed,
                    ),
                    PublishSection(
                      title: 'Especie',
                      child: ChoiceWrap(
                        options: _speciesOptions,
                        selected: _species,
                        onChanged: (v) => setState(() => _species = v),
                      ),
                    ),
                    PublishSection(
                      title: _lost
                          ? 'Barrio donde se perdió'
                          : 'Barrio donde la encontraste',
                      child: ChoiceWrap(
                        options: _neighborhoods,
                        selected: _neighborhood,
                        onChanged: (v) => setState(() => _neighborhood = v),
                      ),
                    ),
                    if (_lost)
                      PublishSection(
                        title: 'Recompensa voluntaria',
                        subtitle:
                            'Se retiene y solo se libera cuando ambos confirman la entrega',
                        child: ChoiceWrap(
                          options: _rewards,
                          selected: _reward,
                          onChanged: (v) => setState(() => _reward = v),
                        ),
                      )
                    else
                      QuestionsEditor(
                        fields: _questions,
                        onChanged: () => setState(() {}),
                      ),
                  ],
                ),
              ),
              PublishBottomBar(
                enabled: _valid,
                onPublish: () => _publish(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
