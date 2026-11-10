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

class PublishObjectScreen extends StatefulWidget {
  const PublishObjectScreen({super.key});

  @override
  State<PublishObjectScreen> createState() => _PublishObjectScreenState();
}

class _PublishObjectScreenState extends State<PublishObjectScreen> {
  bool _lost = true;
  List<Uint8List> _photos = [];
  String? _category;
  String? _place;
  String _reward = '\$0';
  final _title = TextEditingController();
  final _questions = [
    QuestionFields(question: '¿Qué marca es?'),
    QuestionFields(question: '¿Qué tiene grabado o pegado?'),
    QuestionFields(),
  ];

  static const _categories = [
    'Celular',
    'Mochila',
    'Billetera',
    'Llaves',
    'Audífonos',
    'Termo',
    'Cartuchera',
    'Parlante',
    'Otro',
  ];
  static const _places = [
    'Biblioteca',
    'Cafetería',
    'Edificio A',
    'Edificio L',
    'Bienestar',
    'Coliseo',
  ];
  static const _rewards = ['\$0', '\$20.000', '\$50.000'];

  @override
  void dispose() {
    _title.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  bool get _valid {
    final base =
        _photos.isNotEmpty &&
        _title.text.trim().isNotEmpty &&
        _category != null &&
        _place != null;
    return _lost ? base : base && _questions.every((q) => q.complete);
  }

  void _publish(BuildContext context) {
    context.read<PublishCubit>().publish(
      NewPost(
        kind: PostKind.object,
        intent: _lost ? PostIntent.lost : PostIntent.found,
        title: _title.text,
        description: _title.text,
        category: _category!,
        place: _place!,
        photos: _photos,
        reward: _lost ? parseCop(_reward) : null,
        questions: _lost ? const [] : _questions.map((q) => q.toNew()).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PublishScope(
      kind: () => _lost ? PublishKinds.objectLost : PublishKinds.objectFound,
      child: Builder(
        builder: (context) => FdScaffold(
          body: Column(
            children: [
              FdScreenHeader(
                title: 'Publicar objeto',
                trailing: FdIconButton(
                  icon: Icons.pets_rounded,
                  tooltip: 'Cambiar a mascota',
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.publishPet,
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
                      options: const {true: 'Lo perdí', false: 'Lo encontré'},
                      selected: _lost,
                      onChanged: (v) => setState(() => _lost = v),
                    ),
                    const SizedBox(height: FdSpacing.md),
                    PhotoPicker(
                      photos: _photos,
                      onChanged: (v) => setState(() => _photos = v),
                    ),
                    const SizedBox(height: FdSpacing.md),
                    FdTextField(
                      label: 'Descripción pública',
                      hint: _lost
                          ? 'Audífonos blancos en estuche'
                          : 'Qué encontraste, sin detalles privados',
                      controller: _title,
                      onChanged: (_) => setState(() {}),
                    ),
                    PublishSection(
                      title: 'Categoría',
                      child: ChoiceWrap(
                        options: _categories,
                        selected: _category,
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ),
                    PublishSection(
                      title: _lost
                          ? 'Lugar donde lo perdiste'
                          : 'Lugar donde lo encontraste',
                      child: ChoiceWrap(
                        options: _places,
                        selected: _place,
                        onChanged: (v) => setState(() => _place = v),
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
