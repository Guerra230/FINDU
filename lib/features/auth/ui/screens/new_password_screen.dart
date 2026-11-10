import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/features/auth/ui/bloc/recovery_cubit.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';
import 'package:findu/features/auth/ui/widgets/recovery_scope.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryScope(
      onDone: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.popUntil(context, (route) => route.isFirst);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada. Ya puedes ingresar.'),
          ),
        );
      },
      child: const _NewPasswordView(),
    );
  }
}

class _NewPasswordView extends StatefulWidget {
  const _NewPasswordView();

  @override
  State<_NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<_NewPasswordView> {
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  String? get _passwordError {
    final value = _password.text;
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!value.contains(RegExp(r'[A-Za-z]')) ||
        !value.contains(RegExp(r'\d'))) {
      return 'Usa al menos una letra y un número';
    }
    return null;
  }

  String? get _repeatError =>
      _repeat.text == _password.text ? null : 'Las contraseñas no coinciden';

  void _save() {
    setState(() => _submitted = true);
    if (_passwordError != null || _repeatError != null) return;
    context.read<RecoveryCubit>().updatePassword(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      headerTitle: 'Nueva contraseña',
      bottom: BlocBuilder<RecoveryCubit, RecoveryState>(
        builder: (context, state) => FdButton(
          label: 'Guardar contraseña',
          isLoading: state.status == RecoveryStatus.loading,
          onPressed: _save,
        ),
      ),
      children: [
        Text('Crea tu nueva contraseña', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          'Usa mínimo 8 caracteres, con una letra y un número.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        FdTextField(
          label: 'Nueva contraseña',
          controller: _password,
          isPassword: true,
          errorText: _submitted ? _passwordError : null,
        ),
        const SizedBox(height: FdSpacing.sm),
        FdTextField(
          label: 'Repite la contraseña',
          controller: _repeat,
          isPassword: true,
          errorText: _submitted ? _repeatError : null,
        ),
      ],
    );
  }
}
