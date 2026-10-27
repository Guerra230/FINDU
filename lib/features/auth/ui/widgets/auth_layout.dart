import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.headerTitle,
    required this.children,
    required this.bottom,
    this.showBack = true,
  });

  final String headerTitle;
  final List<Widget> children;
  final Widget bottom;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(title: headerTitle, showBack: showBack),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: children,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: bottom,
          ),
        ],
      ),
    );
  }
}

class TermsCheck extends StatelessWidget {
  const TermsCheck({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        borderRadius: BorderRadius.circular(FdRadius.sm),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: FdSpacing.xs),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: FdColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              Expanded(
                child: Text('Acepto los términos y la política de datos', style: FdTypography.body),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTypeSwitch extends StatelessWidget {
  const AccountTypeSwitch({super.key, required this.isStudent, required this.onChanged});

  final bool isStudent;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FdSegmented<bool>(
      options: const {true: 'Universitario', false: 'Ciudadano'},
      selected: isStudent,
      onChanged: onChanged,
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({super.key, required this.question, required this.action, required this.onTap});

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: FdTypography.caption),
        TextButton(
          onPressed: onTap,
          child: Text(action, style: FdTypography.bodyStrong.copyWith(color: FdColors.primary)),
        ),
      ],
    );
  }
}
