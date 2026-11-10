import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/publish/ui/bloc/publish_cubit.dart';

abstract final class PublishKinds {
  static const objectLost = 'objeto-perdido';
  static const objectFound = 'objeto-encontrado';
  static const petLost = 'mascota-perdida';
  static const petFound = 'mascota-encontrada';
}

class PublishedArgs {
  const PublishedArgs({required this.postId, required this.kind});

  final String postId;
  final String kind;
}

Future<Uint8List?> pickPhoto() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1600,
    imageQuality: 80,
  );
  return file?.readAsBytes();
}

class PublishScope extends StatelessWidget {
  const PublishScope({super.key, required this.kind, required this.child});

  final String Function() kind;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PublishCubit(context.read<PostsRepository>()),
      child: BlocListener<PublishCubit, PublishState>(
        listener: (context, state) {
          if (state.status == PublishStatus.done && state.postId != null) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.published,
              arguments: PublishedArgs(postId: state.postId!, kind: kind()),
            );
          }
          if (state.status == PublishStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No pudimos publicar. Revisa tu conexión e intenta de nuevo.',
                ),
              ),
            );
          }
        },
        child: child,
      ),
    );
  }
}

class PublishSection extends StatelessWidget {
  const PublishSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: FdSpacing.md),
      child: FdGlass(
        strong: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: FdTypography.bodyStrong),
            if (subtitle != null) Text(subtitle!, style: FdTypography.caption),
            const SizedBox(height: FdSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

class ChoiceWrap extends StatelessWidget {
  const ChoiceWrap({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: FdSpacing.xs,
      runSpacing: FdSpacing.xs,
      children: [
        for (final option in options)
          FdChip(
            label: option,
            selected: option == selected,
            onTap: () => onChanged(option),
          ),
      ],
    );
  }
}

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
    required this.photos,
    required this.onChanged,
    this.title = 'Sube una foto',
    this.hint = 'Una foto clara ayuda a reconocerlo',
  });

  final List<Uint8List> photos;
  final ValueChanged<List<Uint8List>> onChanged;
  final String title;
  final String hint;

  Future<void> _add(BuildContext context) async {
    final bytes = await pickPhoto();
    if (bytes != null) onChanged([...photos, bytes]);
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return FdGlass(
        strong: true,
        onTap: () => _add(context),
        padding: const EdgeInsets.all(FdSpacing.lg),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: FdColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: FdColors.primary,
              ),
            ),
            const SizedBox(height: FdSpacing.sm),
            Text(title, style: FdTypography.bodyStrong),
            Text(hint, style: FdTypography.caption),
          ],
        ),
      );
    }
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < photos.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: FdSpacing.sm),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(FdRadius.md),
                    child: Image.memory(
                      photos[i],
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onChanged([...photos]..removeAt(i)),
                      child: const CircleAvatar(
                        radius: 13,
                        backgroundColor: FdColors.surface,
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: FdColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (photos.length < 3)
            FdGlass(
              strong: true,
              onTap: () => _add(context),
              padding: EdgeInsets.zero,
              child: const SizedBox(
                width: 110,
                height: 110,
                child: Icon(
                  Icons.add_rounded,
                  color: FdColors.primary,
                  size: 32,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class QuestionFields {
  QuestionFields({String question = ''})
    : question = TextEditingController(text: question),
      answer = TextEditingController();

  final TextEditingController question;
  final TextEditingController answer;

  bool get complete =>
      question.text.trim().isNotEmpty && answer.text.trim().isNotEmpty;

  NewQuestion toNew() => NewQuestion(text: question.text, answer: answer.text);

  void dispose() {
    question.dispose();
    answer.dispose();
  }
}

class QuestionsEditor extends StatelessWidget {
  const QuestionsEditor({
    super.key,
    required this.fields,
    required this.onChanged,
  });

  final List<QuestionFields> fields;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return PublishSection(
      title: 'Preguntas privadas',
      subtitle:
          'Escribe 3 preguntas y su respuesta. Solo el dueño real debería saberlas. Las respuestas se guardan cifradas.',
      child: Column(
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            FdTextField(
              label: 'Pregunta ${i + 1}',
              controller: fields[i].question,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: FdSpacing.xs),
            FdTextField(
              label: 'Respuesta ${i + 1} (privada)',
              controller: fields[i].answer,
              onChanged: (_) => onChanged(),
            ),
            if (i < fields.length - 1) const SizedBox(height: FdSpacing.md),
          ],
        ],
      ),
    );
  }
}

class PublishBottomBar extends StatelessWidget {
  const PublishBottomBar({
    super.key,
    required this.enabled,
    required this.onPublish,
  });

  final bool enabled;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FdSpacing.screen,
        FdSpacing.xs,
        FdSpacing.screen,
        FdSpacing.md,
      ),
      child: BlocBuilder<PublishCubit, PublishState>(
        builder: (context, state) => FdButton(
          label: 'Publicar',
          isLoading: state.status == PublishStatus.sending,
          onPressed: enabled ? onPublish : null,
        ),
      ),
    );
  }
}
