import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    setState(() => _submitted = true);
    if (_user.text.trim().isEmpty || _password.text.isEmpty) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FdColors.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 340,
            decoration: const BoxDecoration(
              gradient: FdGradients.heroInverse,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(FdRadius.xl)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.lg, FdSpacing.screen, FdSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(alignment: Alignment.topRight, child: FdMascot(mood: FdMood.feliz, size: 110)),
                    const Spacer(),
                    Text('Ingresar', style: FdTypography.display.copyWith(color: FdColors.onPrimary)),
                    const SizedBox(height: FdSpacing.xs),
                    Text(
                      'Objetos y mascotas perdidas',
                      style: FdTypography.body.copyWith(color: FdColors.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(FdSpacing.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FdTextField(
                  label: 'Correo institucional o celular',
                  hint: 'tu@universidad.edu.co o 300 123 4567',
                  controller: _user,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  errorText: _submitted && _user.text.trim().isEmpty ? 'Escribe tu correo o celular' : null,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: FdSpacing.sm),
                FdTextField(
                  label: 'Contraseña',
                  controller: _password,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  errorText: _submitted && _password.text.isEmpty ? 'Escribe tu contraseña' : null,
                  onChanged: (_) => setState(() {}),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: FdTypography.caption.copyWith(color: FdColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: FdSpacing.xl),
                FdButton(label: 'Ingresar', onPressed: _login),
                const SizedBox(height: FdSpacing.xs),
                AuthFooterLink(
                  question: '¿No tienes cuenta?',
                  action: 'Crear una',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.registerStudent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
