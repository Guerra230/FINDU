import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/ui/bloc/community_form_cubit.dart';

class CreateCommunityScreen extends StatelessWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateCommunityCubit>(),
      child: const _CreateCommunityView(),
    );
  }
}

class _CreateCommunityView extends StatefulWidget {
  const _CreateCommunityView();

  @override
  State<_CreateCommunityView> createState() => _CreateCommunityViewState();
}

class _CreateCommunityViewState extends State<_CreateCommunityView> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  String? _type;
  bool _evidence = false;

  static final _types = communityTypes.keys.toList();

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  bool get _valid =>
      _name.text.trim().isNotEmpty &&
      _type != null &&
      _address.text.trim().isNotEmpty &&
      _evidence;

  void _onState(BuildContext context, CommunityFormState state) {
    if (state.status == CommunityFormStatus.created) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.createSent,
        arguments: state.communityName,
      );
    }
    if (state.status == CommunityFormStatus.failure && state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCommunityCubit, CommunityFormState>(
      listener: _onState,
      child: FdScaffold(
        body: Column(
          children: [
            const FdScreenHeader(title: 'Crear comunidad'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FdSpacing.screen,
                  FdSpacing.xs,
                  FdSpacing.screen,
                  FdSpacing.lg,
                ),
                children: [
                  FdTextField(
                    label: 'Nombre de la comunidad',
                    hint: 'Ciudad Pacífica',
                    controller: _name,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: FdSpacing.md),
                  FdGlass(
                    strong: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de comunidad',
                          style: FdTypography.bodyStrong,
                        ),
                        const SizedBox(height: FdSpacing.sm),
                        Wrap(
                          spacing: FdSpacing.xs,
                          runSpacing: FdSpacing.xs,
                          children: [
                            for (final t in _types)
                              FdChip(
                                label: t,
                                selected: _type == t,
                                onTap: () => setState(() => _type = t),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FdSpacing.md),
                  FdTextField(
                    label: 'Ubicación (dirección)',
                    hint: 'Calle 18 # 122-135, Cali',
                    controller: _address,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: FdSpacing.md),
                  FdListRow(
                    leading: Icon(
                      _evidence
                          ? Icons.check_circle_rounded
                          : Icons.attach_file_rounded,
                      color: FdColors.primary,
                    ),
                    title: _evidence
                        ? 'Evidencia adjunta'
                        : 'Adjunta evidencia',
                    subtitle: 'Acta, NIT o dominio del correo',
                    onTap: () => setState(() => _evidence = !_evidence),
                  ),
                  const SizedBox(height: FdSpacing.md),
                  const FdInfoNote(
                    message:
                        'Tú quedarás como administrador y recibirás un código de acceso para compartir con los miembros.',
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
              child: BlocBuilder<CreateCommunityCubit, CommunityFormState>(
                builder: (context, state) => FdButton(
                  label: 'Crear comunidad',
                  isLoading: state.isSending,
                  onPressed: _valid && !state.isSending
                      ? () => context.read<CreateCommunityCubit>().create(
                          NewCommunity(
                            name: _name.text,
                            type: _type!,
                            address: _address.text,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
