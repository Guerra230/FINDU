import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';

class DesignSystemGallery extends StatefulWidget {
  const DesignSystemGallery({super.key});

  @override
  State<DesignSystemGallery> createState() => _DesignSystemGalleryState();
}

class _DesignSystemGalleryState extends State<DesignSystemGallery> {
  String _intent = 'perdi';
  String _chip = 'todo';
  String? _option = 'codigo';
  bool _toggle = true;

  static const _colors = <String, Color>{
    'background': FdColors.background,
    'primary': FdColors.primary,
    'primaryLight': FdColors.primaryLight,
    'primarySoft': FdColors.primarySoft,
    'textPrimary': FdColors.textPrimary,
    'textSecondary': FdColors.textSecondary,
    'lost': FdColors.lost,
    'warning': FdColors.warning,
    'success': FdColors.success,
  };

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Design system'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.xxl),
              children: [
                const _Section('Findi'),
                Wrap(
                  spacing: FdSpacing.md,
                  runSpacing: FdSpacing.md,
                  children: [
                    for (final mood in FdMood.values)
                      Column(
                        children: [
                          FdMascot(mood: mood, size: 90),
                          Text(mood.name, style: FdTypography.caption),
                        ],
                      ),
                  ],
                ),
                const _Section('Colores'),
                Wrap(
                  spacing: FdSpacing.xs,
                  runSpacing: FdSpacing.xs,
                  children: [
                    for (final entry in _colors.entries)
                      Container(
                        width: 104,
                        height: 64,
                        padding: const EdgeInsets.all(FdSpacing.xs),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(FdRadius.sm),
                          border: Border.all(color: FdColors.border),
                        ),
                        child: Text(
                          entry.key,
                          style: FdTypography.label.copyWith(
                            color: entry.value.computeLuminance() > 0.5 ? FdColors.textPrimary : FdColors.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const _Section('Tipografía'),
                Text('Encuéntralo', style: FdTypography.display),
                Text('¡Recibiste a Luna!', style: FdTypography.h1),
                Text('Publicar objeto', style: FdTypography.title),
                Text('Recientes', style: FdTypography.h2),
                Text('Laura Gómez aprobó tus 3 respuestas.', style: FdTypography.body),
                Text('Ciudad Pacífica, hace 1 h', style: FdTypography.caption),
                Text('ENTREGA VERIFICADA', style: FdTypography.overline),
                const _Section('Botones'),
                FdButton(label: 'Publicar', onPressed: () {}),
                const SizedBox(height: FdSpacing.sm),
                FdButton(label: 'Ver mis comunidades', variant: FdButtonVariant.secondary, onPressed: () {}),
                const SizedBox(height: FdSpacing.sm),
                FdButton(label: 'Hubo un problema', variant: FdButtonVariant.danger, onPressed: () {}),
                FdButton(label: 'Volver al inicio', variant: FdButtonVariant.ghost, onPressed: () {}),
                const SizedBox(height: FdSpacing.sm),
                Row(
                  children: [
                    FdIconButton(icon: Icons.chevron_left_rounded, onPressed: () {}),
                    const SizedBox(width: FdSpacing.sm),
                    FdIconButton(icon: Icons.notifications_none_rounded, badgeCount: 3, onPressed: () {}),
                    const SizedBox(width: FdSpacing.sm),
                    FdIconButton(icon: Icons.tune_rounded, filled: true, onPressed: () {}),
                  ],
                ),
                const _Section('Campos y selectores'),
                const FdTextField(label: 'Correo institucional o celular', hint: 'tu@universidad.edu.co'),
                const SizedBox(height: FdSpacing.sm),
                const FdTextField(label: 'Contraseña', isPassword: true),
                const SizedBox(height: FdSpacing.md),
                FdSegmented<String>(
                  options: const {'perdi': 'Lo perdí', 'encontre': 'Lo encontré'},
                  selected: _intent,
                  onChanged: (v) => setState(() => _intent = v),
                ),
                const SizedBox(height: FdSpacing.md),
                FdChipBar<String>(
                  padding: EdgeInsets.zero,
                  options: const {'todo': 'Todo', 'objetos': 'Objetos', 'mascotas': 'Mascotas', 'celular': 'Celular'},
                  selected: _chip,
                  onChanged: (v) => setState(() => _chip = v),
                ),
                const SizedBox(height: FdSpacing.md),
                FdOptionCards<String>(
                  options: const [
                    FdOption(value: 'codigo', title: 'Código de acceso', subtitle: 'Te lo comparte el administrador'),
                    FdOption(value: 'aprobacion', title: 'Solicitar aprobación al admin', subtitle: 'El admin revisa tu solicitud'),
                  ],
                  selected: _option,
                  onChanged: (v) => setState(() => _option = v),
                ),
                FdGlass(
                  strong: true,
                  padding: EdgeInsets.zero,
                  child: FdToggleRow(
                    label: 'Mascotas perdidas cerca de mí',
                    value: _toggle,
                    onChanged: (v) => setState(() => _toggle = v),
                  ),
                ),
                const _Section('Estados y etiquetas'),
                Wrap(
                  spacing: FdSpacing.xs,
                  runSpacing: FdSpacing.xs,
                  children: [
                    for (final status in FdStatus.values) FdBadge.status(status),
                    const FdTag(label: 'Asustado'),
                  ],
                ),
                const SizedBox(height: FdSpacing.md),
                const FdSteps(current: 2),
                const SizedBox(height: FdSpacing.md),
                const FdInfoNote(message: 'Toda comunidad tiene un administrador. Entras con un código o cuando el admin te acepta.'),
                const SizedBox(height: FdSpacing.md),
                FdListRow(
                  leading: const FdAvatar(name: 'Laura Gómez'),
                  title: 'Laura Gómez',
                  subtitle: 'Luna · gata perdida',
                  onTap: () {},
                ),
                const _Section('Tarjeta de publicación'),
                Row(
                  children: [
                    FdPostCard(
                      title: 'Luna',
                      subtitle: 'Ciudad Pacífica, hace 1 h',
                      status: FdStatus.lost,
                      icon: Icons.pets_rounded,
                      onTap: () {},
                      onMap: () {},
                      width: 160,
                      height: 230,
                    ),
                    const SizedBox(width: FdSpacing.sm),
                    FdPostCard(
                      title: 'Mochila',
                      subtitle: 'Universidad Icesi',
                      status: FdStatus.found,
                      feminine: true,
                      icon: Icons.backpack_outlined,
                      onTap: () {},
                      width: 160,
                      height: 230,
                    ),
                  ],
                ),
                const _Section('Encabezado de resultado y hoja'),
                const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(FdRadius.lg)),
                  child: FdResultHero(mood: FdMood.feliz, tag: 'Entrega verificada', height: 240),
                ),
                const SizedBox(height: FdSpacing.md),
                FdButton(
                  label: 'Abrir hoja de confirmación',
                  variant: FdButtonVariant.secondary,
                  onPressed: () => showFdBottomSheet<void>(
                    context,
                    builder: (context) => FdSheetContent(
                      title: '¿Cómo salió la entrega?',
                      message: 'Ambos deben confirmar. Cuando los dos confirman, la recompensa se libera.',
                      note: 'Laura Gómez ya confirmó que recibió a Luna',
                      primaryLabel: 'Sí, la entrega se hizo',
                      onPrimary: () => Navigator.pop(context),
                      secondaryLabel: 'No, hubo un problema',
                      secondaryIsDanger: true,
                      onSecondary: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const _Section('Estado vacío'),
                const FdEmptyState(
                  mood: FdMood.esperando,
                  title: 'Aún no tienes chats',
                  message: 'Cuando verifiques un objeto o reportes un hallazgo, el chat aparece aquí.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: FdSpacing.xl, bottom: FdSpacing.sm),
      child: Text(title, style: FdTypography.h2),
    );
  }
}
