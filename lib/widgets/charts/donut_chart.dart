import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/resumos.dart';
import '../../theme/app_colors.dart';

/// Gráfico de rosca com um valor no centro (ex.: "R$ 1.640" / "despesas").
class DonutChart extends StatelessWidget {
  final List<FatiaCategoria> fatias;
  final String centerValue;
  final String centerLabel;
  final double size;
  final double strokeWidth;

  const DonutChart({
    super.key,
    required this.fatias,
    required this.centerValue,
    required this.centerLabel,
    this.size = 132,
    this.strokeWidth = 17,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, progresso, child) => CustomPaint(
          painter: _DonutPainter(fatias, strokeWidth, progresso),
          child: child,
        ),
        child: Padding(
          padding: EdgeInsets.all(strokeWidth + 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  centerValue,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                centerLabel,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<FatiaCategoria> fatias;
  final double strokeWidth;
  final double progresso;

  _DonutPainter(this.fatias, this.strokeWidth, this.progresso);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final pincel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (fatias.isEmpty) {
      canvas.drawArc(
        rect,
        0,
        math.pi * 2,
        false,
        pincel..color = AppColors.surfaceHigh,
      );
      return;
    }

    // Pequeno espaço entre as fatias, como no design.
    final espaco = fatias.length > 1 ? 0.035 : 0.0;
    var inicio = -math.pi / 2;
    for (final fatia in fatias) {
      final angulo = fatia.percentual * math.pi * 2 * progresso;
      final desenho = math.max(0.0, angulo - espaco);
      canvas.drawArc(
        rect,
        inicio + espaco / 2,
        desenho,
        false,
        pincel..color = fatia.cor,
      );
      inicio += angulo;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progresso != progresso ||
      old.fatias != fatias ||
      old.strokeWidth != strokeWidth;
}
