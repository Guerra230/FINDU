import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';

class _Method {
  const _Method({required this.provider, required this.last4, required this.detail});

  final String provider;
  final String last4;
  final String detail;
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _methods = <_Method>[
    const _Method(provider: 'Nequi', last4: '4506', detail: 'Cuenta Nequi'),
    const _Method(provider: 'Tarjeta Visa', last4: '4417', detail: 'Vence 08/28'),
  ];
  int _default = 0;

  void _add() {
    String? choice = 'nequi';
    showFdBottomSheet<void>(
      context,
      builder: (_) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Agregar método de pago', style: FdTypography.h1),
            const SizedBox(height: FdSpacing.md),
            FdOptionCards<String>(
              options: const [
                FdOption(value: 'nequi', title: 'Nequi', icon: Icons.phone_iphone_rounded),
                FdOption(value: 'tarjeta', title: 'Tarjeta débito o crédito', icon: Icons.credit_card_rounded),
              ],
              selected: choice,
              onChanged: (v) => setSheetState(() => choice = v),
            ),
            FdButton(
              label: 'Continuar',
              onPressed: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('En el Sprint 2 se conecta la pasarela de pago')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Métodos de pago'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                Text('Se usan para impulsar publicaciones y pagar recompensas.', style: FdTypography.caption),
                const SizedBox(height: FdSpacing.md),
                for (var i = 0; i < _methods.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: FdSpacing.sm),
                    child: FdGlass(
                      strong: true,
                      selected: i == _default,
                      onTap: () => setState(() => _default = i),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: FdColors.primarySoft,
                            child: Text(_methods[i].provider[0], style: FdTypography.bodyStrong.copyWith(color: FdColors.primary)),
                          ),
                          const SizedBox(width: FdSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${_methods[i].provider} ····${_methods[i].last4}', style: FdTypography.bodyStrong),
                                Text(
                                  i == _default ? 'Predeterminado' : _methods[i].detail,
                                  style: FdTypography.caption.copyWith(color: i == _default ? FdColors.primary : null),
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
                  onPressed: _add,
                ),
                const SizedBox(height: FdSpacing.md),
                const FdInfoNote(
                  icon: Icons.lock_outline_rounded,
                  message: 'FINDU nunca guarda los números completos. Las recompensas se retienen hasta que ambos confirman la entrega.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
