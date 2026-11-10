import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/bloc/recovery_cubit.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';
import 'package:findu/features/auth/ui/widgets/recovery_scope.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryScope(
      onDone: (context, state) => Navigator.pushNamed(
        context,
        AppRoutes.recoveryCode,
        arguments: state.email,
      ),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _user = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _user.dispose();
    super.dispose();
  }

  void _send() {
    setState(() => _submitted = true);
    if (_user.text.trim().isEmpty) return;
    context.read<RecoveryCubit>().sendCode(_user.text);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      headerTitle: 'Recuperar contraseña',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<RecoveryCubit, RecoveryState>(
            builder: (context, state) => FdButton(
              label: 'Enviar código',
              isLoading: state.status == RecoveryStatus.loading,
              onPressed: _send,
            ),
          ),
          FdButton(
            label: 'Volver a ingresar',
            variant: FdButtonVariant.ghost,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      children: [
        const Center(child: FdMascot(mood: FdMood.sorprendido, size: 120)),
        const SizedBox(height: FdSpacing.lg),
        Text('¿Olvidaste tu contraseña?', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          'Escribe tu correo o celular y te enviaremos un código para crear una nueva contraseña.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        FdTextField(
          label: 'Correo institucional o celular',
          hint: 'tu@universidad.edu.co o 300 123 4567',
          controller: _user,
          keyboardType: TextInputType.emailAddress,
          errorText: _submitted && _user.text.trim().isEmpty
              ? 'Escribe tu correo o celular'
              : null,
        ),
        const SizedBox(height: FdSpacing.md),
        const FdInfoNote(
          message:
              'El código vence en 15 minutos y solo se puede usar una vez.',
        ),
      ],
    );
  }
}
