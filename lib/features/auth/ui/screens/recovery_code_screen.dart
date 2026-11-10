import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/bloc/recovery_cubit.dart';
import 'package:findu/features/auth/ui/widgets/auth_layout.dart';
import 'package:findu/features/auth/ui/widgets/recovery_scope.dart';

class RecoveryCodeScreen extends StatelessWidget {
  const RecoveryCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RecoveryScope(
      onDone: (context, state) {
        if (state.email != null) {
          Navigator.pushNamed(context, AppRoutes.newPassword);
        }
      },
      child: const _RecoveryCodeView(),
    );
  }
}

class _RecoveryCodeView extends StatefulWidget {
  const _RecoveryCodeView();

  @override
  State<_RecoveryCodeView> createState() => _RecoveryCodeViewState();
}

class _RecoveryCodeViewState extends State<_RecoveryCodeView> {
  static const _length = 6;
  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _nodes = List.generate(_length, (_) => FocusNode());
  Timer? _timer;
  int _seconds = 45;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  bool get _complete => _controllers.every((c) => c.text.isNotEmpty);

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) _nodes[index - 1].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final target = ModalRoute.of(context)?.settings.arguments;
    return AuthLayout(
      headerTitle: 'Recuperar contraseña',
      bottom: BlocBuilder<RecoveryCubit, RecoveryState>(
        builder: (context, state) => FdButton(
          label: 'Verificar',
          isLoading: state.status == RecoveryStatus.loading,
          onPressed: _complete && target is String
              ? () => context.read<RecoveryCubit>().verifyCode(
                  email: target,
                  code: _controllers.map((c) => c.text).join(),
                )
              : null,
        ),
      ),
      children: [
        Text('Revisa tu correo o celular', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          target is String
              ? 'Enviamos un código de 6 dígitos a $target. Escríbelo para crear una nueva contraseña.'
              : 'Te enviamos un código de 6 dígitos. Escríbelo para crear una nueva contraseña.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        Row(
          children: [
            for (var i = 0; i < _length; i++) ...[
              Expanded(
                child: FdGlass(
                  strong: true,
                  selected: _nodes[i].hasFocus,
                  padding: EdgeInsets.zero,
                  radius: FdRadius.sm,
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _nodes[i],
                        autofocus: i == 0,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        style: FdTypography.h1,
                        cursorColor: FdColors.primary,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (v) => _onChanged(i, v),
                        onTap: () => setState(() {}),
                      ),
                    ),
                  ),
                ),
              ),
              if (i < _length - 1) const SizedBox(width: FdSpacing.xs),
            ],
          ],
        ),
        const SizedBox(height: FdSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: _seconds > 0
              ? Text(
                  'Reenviar código en 0:${_seconds.toString().padLeft(2, '0')}',
                  style: FdTypography.bodyStrong.copyWith(
                    color: FdColors.textSecondary,
                  ),
                )
              : TextButton(
                  onPressed: () {
                    setState(_startTimer);
                    if (target is String) {
                      context.read<RecoveryCubit>().sendCode(target);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Te enviamos un código nuevo'),
                      ),
                    );
                  },
                  child: Text(
                    'Reenviar código',
                    style: FdTypography.bodyStrong.copyWith(
                      color: FdColors.primary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
