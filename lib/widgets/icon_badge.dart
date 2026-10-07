import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ícone dentro de um círculo (ou quadrado arredondado) com a cor do
/// contexto: categoria, receita (verde) ou despesa (vermelho).
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  /// Fundo sólido com ícone escuro; caso contrário, fundo translúcido.
  final bool filled;
  final bool circle;

  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
    this.filled = false,
    this.circle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.14),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: filled ? AppColors.onPrimary : color,
      ),
    );
  }
}
