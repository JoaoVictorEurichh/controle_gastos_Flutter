import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_input.dart';

/// Campo selecionável: rótulo acima, ícone, valor atual e seta ">".
/// O que acontece ao tocar (bottom sheet, date picker...) fica com [onTap].
class AppSelect extends StatelessWidget {
  final String label;
  final Widget leading;
  final String value;
  final VoidCallback onTap;

  const AppSelect({
    super.key,
    required this.label,
    required this.leading,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borda = BorderRadius.circular(AppRadius.md);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        Material(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: borda,
            side: const BorderSide(color: AppColors.border),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: borda,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 58),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    leading,
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
