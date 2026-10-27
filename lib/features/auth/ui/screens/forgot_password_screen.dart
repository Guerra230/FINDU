import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
    Navigator.pushNamed(context, AppRoutes.recoveryCode, arguments: _user.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      headerTitle: 'Recuperar contraseña',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FdButton(label: 'Enviar código', onPressed: _send),
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
          errorText: _submitted && _user.text.trim().isEmpty ? 'Escribe tu correo o celular' : null,
        ),
        const SizedBox(height: FdSpacing.md),
        const FdInfoNote(message: 'El código vence en 15 minutos y solo se puede usar una vez.'),
      ],
    );
  }
}
