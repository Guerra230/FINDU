import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/features/payments/domain/payments_models.dart';
import 'package:findu/features/payments/ui/bloc/payment_methods_cubit.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentMethodsCubit>()..load(),
      child: const _PaymentMethodsView(),
    );
  }
}

class _PaymentMethodsView extends StatelessWidget {
  const _PaymentMethodsView();

  void _add(BuildContext context) {
    final cubit = context.read<PaymentMethodsCubit>();
    final last4 = TextEditingController();
    var choice = PaymentProvider.nequi;
    showFdBottomSheet<void>(
      context,
      builder: (_) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Agregar método de pago', style: FdTypography.h1),
            const SizedBox(height: FdSpacing.md),
            FdOptionCards<PaymentProvider>(
              options: const [
                FdOption(
                  value: PaymentProvider.nequi,
                  title: 'Nequi',
                  icon: Icons.phone_iphone_rounded,
                ),
                FdOption(
                  value: PaymentProvider.card,
                  title: 'Tarjeta débito o crédito',
                  icon: Icons.credit_card_rounded,
                ),
              ],
              selected: choice,
              onChanged: (v) => setSheetState(() => choice = v),
            ),
            FdTextField(
              label: choice == PaymentProvider.nequi
                  ? 'Últimos 4 del celular'
                  : 'Últimos 4 de la tarjeta',
              hint: '4506',
              controller: last4,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: FdSpacing.md),
            FdButton(
              label: 'Guardar',
              onPressed: () async {
                final ok = await cubit.add(choice, last4.text);
                if (ok && sheetContext.mounted) Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
      listenWhen: (a, b) => b.message != null && a.message != b.message,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message!))),
      builder: (context, state) {
        final cubit = context.read<PaymentMethodsCubit>();
        return FdScaffold(
          body: Column(
            children: [
              const FdScreenHeader(title: 'Métodos de pago'),
              Expanded(
                child: state.status == PaymentMethodsStatus.loading
                    ? const FdLoadingState()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          FdSpacing.screen,
                          FdSpacing.xs,
                          FdSpacing.screen,
                          FdSpacing.lg,
                        ),
                        children: [
                          Text(
                            'Se usan para impulsar publicaciones y pagar recompensas.',
                            style: FdTypography.caption,
                          ),
                          const SizedBox(height: FdSpacing.md),
                          if (state.items.isEmpty)
                            const FdEmptyState(
                              mood: FdMood.esperando,
                              title: 'Sin métodos de pago',
                              message:
                                  'Agrega Nequi o una tarjeta para impulsar tus publicaciones.',
                            ),
                          for (final m in state.items)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: FdSpacing.sm,
                              ),
                              child: FdGlass(
                                strong: true,
                                selected: m.isDefault,
                                onTap: () => cubit.makeDefault(m),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: FdColors.primarySoft,
                                      child: Text(
                                        m.providerName[0],
                                        style: FdTypography.bodyStrong.copyWith(
                                          color: FdColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: FdSpacing.sm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.label,
                                            style: FdTypography.bodyStrong,
                                          ),
                                          Text(
                                            m.isDefault
                                                ? 'Predeterminado'
                                                : 'Toca para usarlo por defecto',
                                            style: FdTypography.caption
                                                .copyWith(
                                                  color: m.isDefault
                                                      ? FdColors.primary
                                                      : null,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: FdSpacing.xs),
                          FdButton(
                            label: 'Agregar método de pago',
                            icon: Icons.add_rounded,
                            variant: FdButtonVariant.secondary,
                            onPressed: () => _add(context),
                          ),
                          const SizedBox(height: FdSpacing.md),
                          const FdInfoNote(
                            icon: Icons.lock_outline_rounded,
                            message:
                                'FINDU solo guarda los últimos 4 dígitos, nunca el número completo. Los pagos son simulados.',
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
