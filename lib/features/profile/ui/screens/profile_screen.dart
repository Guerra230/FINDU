import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/bloc/auth_bloc.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/posts/ui/bloc/post_cubit.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyPostsCubit(context.read<PostsRepository>())..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  void _logout(BuildContext context) {
    showFdBottomSheet<void>(
      context,
      builder: (sheetContext) => FdSheetContent(
        title: '¿Cerrar sesión?',
        mood: FdMood.esperando,
        primaryLabel: 'Cerrar sesión',
        onPrimary: () {
          Navigator.pop(sheetContext);
          context.read<AuthBloc>().add(const AuthLogoutRequested());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select((AuthBloc b) => b.state.profile);
    final posts = context.watch<MyPostsCubit>().state;
    final mine = posts ?? const <Post>[];
    final delivered = mine.where((p) => p.isDelivered).length;
    final lost = mine.where((p) => p.isLost && !p.isDelivered).length;
    final name = profile?.name ?? '';

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (a, b) => b.status == AuthStatus.unauthenticated,
      listener: (context, _) => Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
      child: FdBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: context.read<MyPostsCubit>().load,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                FdLargeTitle(
                  title: 'Mi perfil',
                  trailing: FdIconButton(
                    icon: Icons.settings_outlined,
                    tooltip: 'Configurar alertas',
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.alertSettings),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FdSpacing.screen,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FdGlass(
                        strong: true,
                        radius: FdRadius.lg,
                        padding: const EdgeInsets.all(FdSpacing.lg),
                        child: Row(
                          children: [
                            FdAvatar(name: name.isEmpty ? '?' : name, size: 72),
                            const SizedBox(width: FdSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: FdTypography.h2),
                                  Text(
                                    profile?.isStudent == true
                                        ? (profile?.email ?? '')
                                        : (profile?.phone ?? ''),
                                    style: FdTypography.caption,
                                  ),
                                  const SizedBox(height: FdSpacing.xs),
                                  FdTag(
                                    label:
                                        profile?.universityName ??
                                        'Cuenta ciudadana',
                                  ),
                                ],
                              ),
                            ),
                            const FdMascot(mood: FdMood.feliz, size: 64),
                          ],
                        ),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _Stat(
                              value: '$delivered',
                              label: 'Devueltos',
                            ),
                          ),
                          const SizedBox(width: FdSpacing.sm),
                          Expanded(
                            child: _Stat(
                              value: '${mine.length}',
                              label: 'Publicados',
                            ),
                          ),
                          const SizedBox(width: FdSpacing.sm),
                          Expanded(
                            child: _Stat(value: '$lost', label: 'Perdidos'),
                          ),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mis publicaciones',
                              style: FdTypography.h2,
                            ),
                          ),
                          Text(
                            '${mine.length - delivered} activas',
                            style: FdTypography.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      if (posts == null)
                        const FdLoadingState()
                      else if (mine.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: FdSpacing.sm),
                          child: Text(
                            'Aún no has publicado nada.',
                            style: FdTypography.caption,
                          ),
                        )
                      else
                        for (final post in mine)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: FdSpacing.sm,
                            ),
                            child: FdListRow(
                              leading: PostThumb(post: post),
                              title: post.title,
                              subtitle: post.placeAgo,
                              trailing: FdBadge.status(
                                post.status,
                                feminine: post.feminine,
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.postDetail,
                                arguments: post.id,
                              ),
                            ),
                          ),
                      const SizedBox(height: FdSpacing.md),
                      FdListRow(
                        leading: const Icon(
                          Icons.credit_card_rounded,
                          color: FdColors.primary,
                        ),
                        title: 'Métodos de pago',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.paymentMethods,
                        ),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      FdListRow(
                        leading: const Icon(
                          Icons.groups_outlined,
                          color: FdColors.primary,
                        ),
                        title: 'Mis comunidades',
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.communities),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      FdListRow(
                        leading: const Icon(
                          Icons.notifications_none_rounded,
                          color: FdColors.primary,
                        ),
                        title: 'Configurar alertas',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.alertSettings,
                        ),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      FdListRow(
                        leading: const Icon(
                          Icons.logout_rounded,
                          color: FdColors.lost,
                        ),
                        title: 'Cerrar sesión',
                        onTap: () => _logout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: FdTypography.h1.copyWith(color: FdColors.primary)),
          Text(label, style: FdTypography.caption),
        ],
      ),
    );
  }
}
