import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Rótulo exibido acima dos campos ("Valor", "Observações (opcional)").
class FieldLabel extends StatelessWidget {
  final String text;
  final bool optional;

  const FieldLabel(this.text, {super.key, this.optional = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            if (optional)
              const TextSpan(
                text: ' (opcional)',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Decoração padrão dos campos de texto do app.
InputDecoration appInputDecoration({
  String? hint,
  Widget? prefix,
  String? errorText,
  TextStyle? hintStyle,
}) {
  OutlineInputBorder borda(Color cor) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide(color: cor),
  );

  return InputDecoration(
    hintText: hint,
    hintStyle:
        hintStyle ?? const TextStyle(color: AppColors.textMuted, fontSize: 15),
    errorText: errorText,
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    prefixIcon: prefix,
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    enabledBorder: borda(AppColors.border),
    focusedBorder: borda(AppColors.primary),
    errorBorder: borda(AppColors.danger),
    focusedErrorBorder: borda(AppColors.danger),
  );
}

/// Campo de texto com rótulo acima.
class AppInput extends StatelessWidget {
  final String label;
  final bool optional;
  final TextEditingController? controller;
  final String? hint;
  final String? prefixText;
  final String? errorText;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const AppInput({
    super.key,
    required this.label,
    this.optional = false,
    this.controller,
    this.hint,
    this.prefixText,
    this.errorText,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.style,
    this.hintStyle,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, optional: optional),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          autofocus: autofocus,
          textCapitalization: TextCapitalization.sentences,
          style:
              style ??
              const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          decoration: appInputDecoration(
            hint: hint,
            errorText: errorText,
            hintStyle: hintStyle,
            prefix: prefixText == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 16, right: 14),
                    child: Text(
                      prefixText!,
                      style: (style ?? const TextStyle(fontSize: 15)).copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
