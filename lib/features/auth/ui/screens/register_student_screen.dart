import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _terms = false;
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  String? get _emailError {
    final email = _email.text.trim();
    if (email.isEmpty) return 'Escribe tu correo institucional';
    if (!email.contains('@') || !email.contains('.edu')) return 'Usa el correo de tu universidad';
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    final valid = _name.text.trim().isNotEmpty &&
        _emailError == null &&
        _code.text.trim().isNotEmpty &&
        _password.text.length >= 8 &&
        _terms;
    if (!valid) return;
    Navigator.pushNamed(context, AppRoutes.chooseUniversity);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      headerTitle: 'Crear cuenta',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FdButton(label: 'Continuar', onPressed: _submit),
          AuthFooterLink(
            question: '¿Ya tienes cuenta?',
            action: 'Ingresar',
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      children: [
        Text('Crea tu cuenta', style: FdTypography.display),
        const SizedBox(height: FdSpacing.xs),
        Text('Objetos y mascotas perdidas en tu universidad', style: FdTypography.caption),
        const SizedBox(height: FdSpacing.lg),
        AccountTypeSwitch(
          isStudent: true,
          onChanged: (student) {
            if (!student) Navigator.pushReplacementNamed(context, AppRoutes.registerCitizen);
          },
        ),
        const SizedBox(height: FdSpacing.lg),
        FdTextField(
          label: 'Nombre completo',
          controller: _name,
          textInputAction: TextInputAction.next,
          errorText: _submitted && _name.text.trim().isEmpty ? 'Escribe tu nombre' : null,
        ),
        const SizedBox(height: FdSpacing.sm),
        FdTextField(
          label: 'Correo institucional',
          hint: 'tu@universidad.edu.co',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: _submitted ? _emailError : null,
        ),
        const SizedBox(height: FdSpacing.sm),
        FdTextField(
          label: 'Código estudiantil',
          controller: _code,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          errorText: _submitted && _code.text.trim().isEmpty ? 'Escribe tu código' : null,
        ),
        const SizedBox(height: FdSpacing.sm),
        FdTextField(
          label: 'Contraseña',
          controller: _password,
          isPassword: true,
          errorText: _submitted && _password.text.length < 8 ? 'Mínimo 8 caracteres' : null,
        ),
        const SizedBox(height: FdSpacing.sm),
        TermsCheck(value: _terms, onChanged: (v) => setState(() => _terms = v)),
        if (_submitted && !_terms)
          Text('Debes aceptar los términos', style: FdTypography.caption.copyWith(color: FdColors.lost)),
      ],
    );
  }
}
