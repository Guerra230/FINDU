import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/ui/bloc/community_form_cubit.dart';
import 'package:findu/features/communities/ui/widgets/community_parts.dart';

class JoinCommunityScreen extends StatelessWidget {
  const JoinCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JoinCommunityCubit>(),
      child: const _JoinView(),
    );
  }
}

class _JoinView extends StatefulWidget {
  const _JoinView();

  @override
  State<_JoinView> createState() => _JoinViewState();
}

class _JoinViewState extends State<_JoinView> {
  final _community = TextEditingController();
  final _code = TextEditingController();
  String _method = 'codigo';

  @override
  void dispose() {
    _community.dispose();
    _code.dispose();
    super.dispose();
  }

  void _join() {
    final cubit = context.read<JoinCommunityCubit>();
    if (_method == 'aprobacion') {
      cubit.requestToJoin(_community.text);
    } else {
      cubit.joinWithCode(_code.text);
    }
  }

  void _onState(BuildContext context, CommunityFormState state) {
    if (state.status == CommunityFormStatus.requested) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.joinPending,
        arguments: state.communityName,
      );
    }
    if (state.status == CommunityFormStatus.joined) {
      showFdBottomSheet<void>(
        context,
        builder: (sheetContext) => FdSheetContent(
          mood: FdMood.feliz,
          title: '¡Ya eres miembro!',
          message: 'Entraste a ${state.communityName} con el código de acceso.',
          primaryLabel: 'Ver mis comunidades',
          onPrimary: () {
            Navigator.pop(sheetContext);
            goToCommunities(context);
          },
          cancelLabel: null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinCommunityCubit, CommunityFormState>(
      listener: _onState,
      builder: (context, state) {
        final ready = _method == 'aprobacion'
            ? _community.text.trim().isNotEmpty
            : _code.text.trim().isNotEmpty;
        return FdScaffold(
          body: Column(
            children: [
              const FdScreenHeader(title: 'Unirse a una comunidad'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.screen,
                    FdSpacing.xs,
                    FdSpacing.screen,
                    FdSpacing.lg,
                  ),
                  children: [
                    Text('Elige cómo verificarte', style: FdTypography.h2),
                    const SizedBox(height: FdSpacing.sm),
                    FdOptionCards<String>(
                      options: const [
                        FdOption(
                          value: 'codigo',
                          title: 'Código de acceso',
                          subtitle:
                              'Te lo comparte el administrador de la comunidad',
                        ),
                        FdOption(
                          value: 'aprobacion',
                          title: 'Solicitar aprobación al admin',
                          subtitle:
                              'El administrador revisa y acepta tu solicitud',
                        ),
                      ],
                      selected: _method,
                      onChanged: (v) {
                        context.read<JoinCommunityCubit>().clearError();
                        setState(() => _method = v);
                      },
                    ),
                    if (_method == 'codigo')
                      FdTextField(
                        label: 'Código de acceso',
                        hint: 'Ej. LILI-4821',
                        controller: _code,
                        errorText: state.error,
                        onChanged: (_) {
                          context.read<JoinCommunityCubit>().clearError();
                          setState(() {});
                        },
                      )
                    else
                      FdTextField(
                        label: 'Nombre de la comunidad',
                        hint: 'Conjunto Bosques de Lili',
                        controller: _community,
                        errorText: state.error,
                        onChanged: (_) {
                          context.read<JoinCommunityCubit>().clearError();
                          setState(() {});
                        },
                      ),
                    const SizedBox(height: FdSpacing.md),
                    const FdInfoNote(
                      message:
                          'Toda comunidad tiene un administrador. Entras con un código de acceso o cuando el admin aprueba tu solicitud. Puedes estar en varias comunidades.',
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
                  label: _method == 'codigo' ? 'Unirme' : 'Enviar solicitud',
                  isLoading: state.isSending,
                  onPressed: ready && !state.isSending ? _join : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
