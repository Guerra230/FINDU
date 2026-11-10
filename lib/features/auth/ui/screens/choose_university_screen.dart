import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';
import 'package:findu/features/auth/ui/bloc/auth_bloc.dart';
import 'package:findu/features/auth/ui/bloc/universities_cubit.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';

class ChooseUniversityScreen extends StatelessWidget {
  const ChooseUniversityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UniversitiesCubit(context.read<AuthRepository>())..load(),
      child: const _ChooseUniversityView(),
    );
  }
}

class _ChooseUniversityView extends StatefulWidget {
  const _ChooseUniversityView();

  @override
  State<_ChooseUniversityView> createState() => _ChooseUniversityViewState();
}

class _ChooseUniversityViewState extends State<_ChooseUniversityView> {
  String _query = '';
  String? _selectedId;
  String? _error;

  StudentDraft? get _draft {
    final args = ModalRoute.of(context)?.settings.arguments;
    return args is StudentDraft ? args : null;
  }

  void _submit(List<University> universities) {
    final draft = _draft;
    final university = universities
        .where((u) => u.id == _selectedId)
        .firstOrNull;
    if (draft == null || university == null) return;
    if (!university.matches(draft.email)) {
      setState(
        () => _error =
            'Tu correo no es de ${university.name}. Debe terminar en @${university.emailDomain}',
      );
      return;
    }
    setState(() => _error = null);
    context.read<AuthBloc>().add(
      AuthStudentSignUpRequested(draft: draft, university: university),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (_) => false,
          );
        } else if (state.status == AuthStatus.failure && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: BlocBuilder<UniversitiesCubit, UniversitiesState>(
        builder: (context, state) {
          final email = _draft?.email ?? '';
          _selectedId ??= state.items
              .where((u) => u.matches(email))
              .firstOrNull
              ?.id;
          final results = state.items
              .where(
                (u) =>
                    u.name.toLowerCase().contains(_query.trim().toLowerCase()),
              )
              .toList();

          return AuthLayout(
            headerTitle: 'Crear cuenta',
            bottom: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, auth) => FdButton(
                label: 'Crear cuenta',
                isLoading: auth.isLoading,
                onPressed: _selectedId == null || _draft == null
                    ? null
                    : () => _submit(state.items),
              ),
            ),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Elige tu universidad', style: FdTypography.h1),
                        const SizedBox(height: FdSpacing.xs),
                        Text(
                          'FINDU funciona en varias universidades. Tu correo institucional debe ser de la que elijas.',
                          style: FdTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  const FdMascot(mood: FdMood.buscando, size: 72),
                ],
              ),
              const SizedBox(height: FdSpacing.lg),
              FdTextField(
                label: 'Buscar universidad',
                hint: 'Escribe el nombre',
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: FdSpacing.md),
              if (_error != null) ...[
                FdInfoNote(icon: Icons.error_outline_rounded, message: _error!),
                const SizedBox(height: FdSpacing.md),
              ],
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.all(FdSpacing.xl),
                  child: FdLoadingState(),
                )
              else if (state.error != null)
                FdErrorState(
                  message: state.error!,
                  onRetry: () => context.read<UniversitiesCubit>().load(),
                )
              else if (results.isEmpty)
                const FdEmptyState(
                  title: 'No la encontramos',
                  message: 'Revisa el nombre o solicita que la agreguemos.',
                )
              else
                FdOptionCards<String>(
                  options: [
                    for (final u in results)
                      FdOption(
                        value: u.id,
                        title: u.name,
                        subtitle: '${u.city} · @${u.emailDomain}',
                      ),
                  ],
                  selected: _selectedId,
                  onChanged: (v) => setState(() {
                    _selectedId = v;
                    _error = null;
                  }),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Recibimos tu solicitud. Te avisaremos cuando esté.',
                      ),
                    ),
                  ),
                  child: Text(
                    '¿No está tu universidad? Solicita agregarla',
                    style: FdTypography.bodyStrong.copyWith(
                      color: FdColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
