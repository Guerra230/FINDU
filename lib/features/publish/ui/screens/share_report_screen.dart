import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class ShareReportScreen extends StatelessWidget {
  const ShareReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PostLoader(
      postId: routeId(context),
      builder: (context, post) => _ShareView(post: post),
    );
  }
}

class _ShareView extends StatelessWidget {
  const _ShareView({required this.post});

  final Post post;

  static const _channels = <(IconData, String)>[
    (Icons.chat_outlined, 'WhatsApp'),
    (Icons.camera_alt_outlined, 'Instagram'),
    (Icons.link_rounded, 'Copiar enlace'),
    (Icons.more_horiz_rounded, 'Más'),
  ];

  @override
  Widget build(BuildContext context) {
    final status = post.isLost
        ? (post.feminine ? 'Perdida' : 'Perdido')
        : (post.feminine ? 'Encontrada' : 'Encontrado');
    final text =
        '$status en FINDU: ${post.title} · ${post.place}'
        '${post.reward == null ? '' : ' · Recompensa ${formatCop(post.reward!)}'}. Código: ${post.id.substring(0, 8)}';

    Future<void> share(String channel) async {
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            channel == 'Copiar enlace'
                ? 'Texto copiado'
                : 'Texto copiado para $channel',
          ),
        ),
      );
    }

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Compartir reporte'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                FdListRow(
                  leading: PostThumb(post: post, size: 52),
                  title: '${post.title} · ${post.place}',
                  subtitle: post.reward == null
                      ? status
                      : '$status · Recompensa ${formatCop(post.reward!)}',
                ),
                const SizedBox(height: FdSpacing.lg),
                Text('¿Dónde lo compartes?', style: FdTypography.h2),
                const SizedBox(height: FdSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final (icon, label) in _channels)
                      Column(
                        children: [
                          FdGlass(
                            strong: true,
                            radius: FdRadius.md,
                            padding: const EdgeInsets.all(FdSpacing.md),
                            onTap: () => share(label),
                            child: Icon(
                              icon,
                              color: FdColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: FdSpacing.xs),
                          Text(label, style: FdTypography.caption),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: FdSpacing.lg),
                FdInfoNote(
                  message:
                      'El texto describe ${post.title}. No incluye tu número ni tu correo.',
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
              label: 'Listo',
              variant: FdButtonVariant.secondary,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
