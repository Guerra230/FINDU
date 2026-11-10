import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/auth/domain/auth_repository.dart';
import 'package:findu/features/auth/ui/bloc/recovery_cubit.dart';

class RecoveryScope extends StatelessWidget {
  const RecoveryScope({super.key, required this.onDone, required this.child});

  final void Function(BuildContext context, RecoveryState state) onDone;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecoveryCubit(context.read<AuthRepository>()),
      child: BlocListener<RecoveryCubit, RecoveryState>(
        listener: (context, state) {
          if (state.status == RecoveryStatus.done) onDone(context, state);
          if (state.status == RecoveryStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: child,
      ),
    );
  }
}
