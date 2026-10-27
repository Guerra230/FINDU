import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';

class ShareReportScreen extends StatelessWidget {
  const ShareReportScreen({super.key});

  static const _channels = <(IconData, String)>[
    (Icons.chat_outlined, 'WhatsApp'),
    (Icons.camera_alt_outlined, 'Instagram'),
    (Icons.link_rounded, 'Copiar enlace'),
    (Icons.more_horiz_rounded, 'Más'),
  ];

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));
    final link = 'https://findu.app/p/${post.id}';

    Future<void> share(String channel) async {
      await Clipboard.setData(ClipboardData(text: link));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(channel == 'Copiar enlace' ? 'Enlace copiado' : 'Enlace copiado para $channel')),
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
                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: FdColors.primarySoft,
                      borderRadius: BorderRadius.circular(FdRadius.sm),
                    ),
                    child: Icon(post.icon, color: FdColors.primary),
                  ),
                  title: '${post.title} · ${post.place}',
                  subtitle: post.reward == null
                      ? (post.status == FdStatus.lost ? 'Perdido' : 'Encontrado')
                      : '${post.feminine ? 'Perdida' : 'Perdido'} · Recompensa ${formatCop(post.reward!)}',
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
                            child: Icon(icon, color: FdColors.primary, size: 28),
                          ),
                          const SizedBox(height: FdSpacing.xs),
                          Text(label, style: FdTypography.caption),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: FdSpacing.lg),
                FdInfoNote(message: 'El enlace abre el reporte de ${post.title}. No incluye tu número ni tu correo.'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(label: 'Listo', variant: FdButtonVariant.secondary, onPressed: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }
}
