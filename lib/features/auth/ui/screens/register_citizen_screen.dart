import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';

class RegisterCitizenScreen extends StatefulWidget {
  const RegisterCitizenScreen({super.key});

  @override
  State<RegisterCitizenScreen> createState() => _RegisterCitizenScreenState();
}

class _RegisterCitizenScreenState extends State<RegisterCitizenScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _terms = false;
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? get _phoneError {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Escribe tu celular';
    if (digits.length != 10) return 'El celular debe tener 10 dígitos';
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    final valid = _name.text.trim().isNotEmpty && _phoneError == null && _password.text.length >= 8 && _terms;
    if (!valid) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      headerTitle: 'Crear cuenta',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FdButton(label: 'Crear cuenta', onPressed: _submit),
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
        Text('Mascotas y objetos perdidos en tu barrio', style: FdTypography.caption),
        const SizedBox(height: FdSpacing.lg),
        AccountTypeSwitch(
          isStudent: false,
          onChanged: (student) {
            if (student) Navigator.pushReplacementNamed(context, AppRoutes.registerStudent);
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
          label: 'Celular',
          hint: '300 123 4567',
          controller: _phone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          errorText: _submitted ? _phoneError : null,
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
