import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SegmentOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SegmentOption(this.value, this.label, {this.icon});
}

/// Seletor em "pílula" usado em Despesa/Receita, nos filtros de período
/// dos relatórios e no filtro de movimentações.
class SegmentedToggle<T> extends StatelessWidget {
  final List<SegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double height;

  /// Cor do texto da opção selecionada (sobre o verde).
  final Color selectedForeground;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height = 46,
    this.selectedForeground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(height / 2.6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final opcao in options)
            Expanded(
              child: _Segmento(opcao: opcao, toggle: this),
            ),
        ],
      ),
    );
  }
}

class _Segmento<T> extends StatelessWidget {
  final SegmentOption<T> opcao;
  final SegmentedToggle<T> toggle;

  const _Segmento({required this.opcao, required this.toggle});

  @override
  Widget build(BuildContext context) {
    final ativo = opcao.value == toggle.selected;
    final cor = ativo ? toggle.selectedForeground : AppColors.textSecondary;
    final raio = BorderRadius.circular((toggle.height - 8) / 2.6);

    return Semantics(
      selected: ativo,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => toggle.onChanged(opcao.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: ativo ? AppColors.primary : Colors.transparent,
            borderRadius: raio,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (opcao.icon != null) ...[
                  Icon(opcao.icon, size: 18, color: cor),
                  const SizedBox(width: 6),
                ],
                Text(
                  opcao.label,
                  style: TextStyle(
                    color: cor,
                    fontSize: 13.5,
                    fontWeight: ativo ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
