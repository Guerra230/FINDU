import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_glass.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdTextField extends StatefulWidget {
  const FdTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.maxLines = 1,
    this.errorText,
    this.onChanged,
    this.textInputAction,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final int maxLines;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  State<FdTextField> createState() => _FdTextFieldState();
}

class _FdTextFieldState extends State<FdTextField> {
  late bool _obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FdGlass(
          strong: true,
          radius: FdRadius.md,
          padding: const EdgeInsets.fromLTRB(FdSpacing.md, FdSpacing.xs, FdSpacing.xs, FdSpacing.xxs),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label, style: FdTypography.label),
                    TextField(
                      controller: widget.controller,
                      keyboardType: widget.keyboardType,
                      obscureText: _obscure,
                      maxLines: widget.isPassword ? 1 : widget.maxLines,
                      onChanged: widget.onChanged,
                      textInputAction: widget.textInputAction,
                      style: FdTypography.bodyStrong,
                      cursorColor: FdColors.primary,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: widget.hint,
                        hintStyle: FdTypography.body.copyWith(color: FdColors.textDisabled),
                        contentPadding: const EdgeInsets.symmetric(vertical: FdSpacing.xs),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: FdColors.primary,
                  ),
                ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: FdSpacing.md, top: FdSpacing.xxs),
            child: Text(widget.errorText!, style: FdTypography.caption.copyWith(color: FdColors.lost)),
          ),
      ],
    );
  }
}
