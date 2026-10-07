import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'app_card.dart';
import 'icon_badge.dart';

/// Texto de variação colorido pelo sinal ("+12%" verde, "-8%" vermelho).
class VariationText extends StatelessWidget {
  final double? percentual;
  final double fontSize;
  final bool showArrow;

  const VariationText(
    this.percentual, {
    super.key,
    this.fontSize = 12,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = percentual;
    if (p == null) {
      return Text(
        '—',
        style: TextStyle(fontSize: fontSize, color: AppColors.textMuted),
      );
    }
    final cor = p.round() >= 0 ? AppColors.primary : AppColors.danger;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showArrow)
          Icon(
            p >= 0 ? Icons.north_east_rounded : Icons.south_east_rounded,
            size: fontSize + 1,
            color: cor,
          ),
        Text(
          formatarVariacao(p),
          style: TextStyle(
            fontSize: fontSize,
            color: cor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Cartão compacto dos Relatórios: ícone, rótulo, valor e variação.
class SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final double? variacao;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.variacao,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: icon, color: iconColor, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                VariationText(variacao, fontSize: 11.5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cartão de destaque do Dashboard (Receitas / Despesas), com fundo
/// levemente tingido pela cor do tipo.
class HighlightSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final Color valueColor;
  final String caption;

  const HighlightSummaryCard({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderColor: color.withValues(alpha: 0.28),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.alphaBlend(color.withValues(alpha: 0.16), AppColors.surface),
          Color.alphaBlend(color.withValues(alpha: 0.05), AppColors.surface),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: icon, color: color, size: 34, filled: true),
          const SizedBox(height: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
