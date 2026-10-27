import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';

abstract final class PublishKinds {
  static const objectLost = 'objeto-perdido';
  static const objectFound = 'objeto-encontrado';
  static const petLost = 'mascota-perdida';
  static const petFound = 'mascota-encontrada';
}

class PublishSection extends StatelessWidget {
  const PublishSection({super.key, required this.title, required this.child, this.subtitle});

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
  const ChoiceWrap({super.key, required this.options, required this.selected, required this.onChanged});

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
          FdChip(label: option, selected: option == selected, onTap: () => onChanged(option)),
      ],
    );
  }
}

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
    required this.count,
    required this.onAdd,
    this.title = 'Sube una foto',
    this.hint = 'Una foto clara ayuda a reconocerlo',
  });

  final int count;
  final VoidCallback onAdd;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      onTap: onAdd,
      padding: const EdgeInsets.all(FdSpacing.lg),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(color: FdColors.primarySoft, shape: BoxShape.circle),
            child: Icon(
              count > 0 ? Icons.check_rounded : Icons.add_a_photo_outlined,
              color: FdColors.primary,
            ),
          ),
          const SizedBox(height: FdSpacing.sm),
          Text(count > 0 ? '$count ${count == 1 ? 'foto agregada' : 'fotos agregadas'}' : title, style: FdTypography.bodyStrong),
          Text(count > 0 ? 'Toca para agregar otra' : hint, style: FdTypography.caption),
        ],
      ),
    );
  }
}

class QuestionsEditor extends StatelessWidget {
  const QuestionsEditor({super.key, required this.controllers, required this.onChanged});

  final List<TextEditingController> controllers;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return PublishSection(
      title: 'Preguntas privadas',
      subtitle: 'Solo el dueño real sabe las respuestas. Escribe 3 preguntas.',
      child: Column(
        children: [
          for (var i = 0; i < controllers.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: FdSpacing.xs),
              child: FdTextField(
                label: 'Pregunta ${i + 1}',
                controller: controllers[i],
                onChanged: (_) => onChanged(),
              ),
            ),
        ],
      ),
    );
  }
}

class PublishBottomBar extends StatelessWidget {
  const PublishBottomBar({super.key, required this.enabled, required this.onPublish});

  final bool enabled;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.md),
      child: FdButton(label: 'Publicar', onPressed: enabled ? onPublish : null),
    );
  }
}
