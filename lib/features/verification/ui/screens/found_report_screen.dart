import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';
import 'package:findu/features/publish/ui/widgets/publish_parts.dart';
import 'package:findu/features/verification/domain/verification_repository.dart';
import 'package:findu/features/verification/ui/bloc/found_report_cubit.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class FoundReportScreen extends StatelessWidget {
  const FoundReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PostLoader(
      postId: routeId(context),
      builder: (context, post) => BlocProvider(
        create: (context) =>
            FoundReportCubit(context.read<VerificationRepository>()),
        child: _FoundReportView(post: post),
      ),
    );
  }
}

class _FoundReportView extends StatefulWidget {
  const _FoundReportView({required this.post});

  final Post post;

  @override
  State<_FoundReportView> createState() => _FoundReportViewState();
}

class _FoundReportViewState extends State<_FoundReportView> {
  var _photos = <Uint8List>[];
  String? _where;
  String? _condition;

  Map<String, String> get _whereOptions => widget.post.isPet
      ? const {
          'Conmigo': 'conmigo',
          'Veterinaria': 'veterinaria',
          'Otro': 'otro',
        }
      : const {'Conmigo': 'conmigo', 'Portería': 'porteria', 'Otro': 'otro'};

  Map<String, String> get _conditionOptions => widget.post.isPet
      ? const {
          'Tranquila': 'buen_estado',
          'Asustada': 'asustado',
          'Herida': 'herido',
        }
      : const {'Buen estado': 'buen_estado', 'Dañado': 'danado'};

  void _onState(BuildContext context, FoundReportState state) {
    if (state.status == FoundReportStatus.done &&
        state.conversationId != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.chat,
        arguments: state.conversationId,
      );
    }
    if (state.status == FoundReportStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pudimos enviar el reporte. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final ready = _photos.isNotEmpty && _where != null && _condition != null;

    return BlocConsumer<FoundReportCubit, FoundReportState>(
      listener: _onState,
      builder: (context, state) => FdScaffold(
        body: Column(
          children: [
            FdScreenHeader(
              title: post.feminine ? 'La encontré' : 'Lo encontré',
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
                  PostSummaryRow(
                    post: post,
                    subtitle: '${post.title} de ${post.authorName}',
                  ),
                  const SizedBox(height: FdSpacing.md),
                  PhotoPicker(
                    photos: _photos,
                    onChanged: (v) => setState(() => _photos = v),
                    title: 'Sube una foto de lo que encontraste',
                    hint:
                        'Ayuda a confirmar que es ${post.feminine ? 'la correcta' : 'el correcto'}',
                  ),
                  const SizedBox(height: FdSpacing.md),
                  Text('¿Dónde está ahora?', style: FdTypography.bodyStrong),
                  const SizedBox(height: FdSpacing.xs),
                  Wrap(
                    spacing: FdSpacing.xs,
                    runSpacing: FdSpacing.xs,
                    children: [
                      for (final o in _whereOptions.entries)
                        FdChip(
                          label: o.key,
                          selected: _where == o.value,
                          onTap: () => setState(() => _where = o.value),
                        ),
                    ],
                  ),
                  const SizedBox(height: FdSpacing.md),
                  Text(
                    post.isPet ? '¿Cómo está?' : 'Estado del objeto',
                    style: FdTypography.bodyStrong,
                  ),
                  const SizedBox(height: FdSpacing.xs),
                  Wrap(
                    spacing: FdSpacing.xs,
                    runSpacing: FdSpacing.xs,
                    children: [
                      for (final o in _conditionOptions.entries)
                        FdChip(
                          label: o.key,
                          selected: _condition == o.value,
                          onTap: () => setState(() => _condition = o.value),
                        ),
                    ],
                  ),
                  const SizedBox(height: FdSpacing.md),
                  FdInfoNote(
                    message: 'Al enviar se abre el chat con ${post.firstName}.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FdSpacing.screen,
                0,
                FdSpacing.screen,
                FdSpacing.md,
              ),
              child: FdButton(
                label: 'Enviar y abrir chat',
                isLoading: state.status == FoundReportStatus.sending,
                onPressed: ready
                    ? () => context.read<FoundReportCubit>().send(
                        postId: post.id,
                        where: _where!,
                        condition: _condition!,
                        photos: _photos,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
