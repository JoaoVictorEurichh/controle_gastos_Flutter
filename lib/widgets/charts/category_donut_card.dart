import 'package:flutter/material.dart';

import '../../models/resumos.dart';
import '../app_card.dart';
import '../empty_state.dart';
import 'category_legend.dart';
import 'donut_chart.dart';

/// Cartão com a rosca de gastos por categoria e a legenda ao lado.
/// Usado no Dashboard ("Resumo do mês") e nos Relatórios.
class CategoryDonutCard extends StatelessWidget {
  static const _larguraMinimaLadoALado = 270.0;

  final String title;
  final List<FatiaCategoria> fatias;
  final String centerValue;
  final String centerLabel;

  const CategoryDonutCard({
    super.key,
    required this.title,
    required this.fatias,
    required this.centerValue,
    required this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          if (fatias.isEmpty)
            const EmptyState(
              icon: Icons.donut_large_rounded,
              message: 'Nenhum gasto no período.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final grafico = DonutChart(
                  fatias: fatias,
                  centerValue: centerValue,
                  centerLabel: centerLabel,
                );
                // Sem espaço para a legenda ao lado: empilha.
                if (constraints.maxWidth < _larguraMinimaLadoALado) {
                  return Column(
                    children: [
                      grafico,
                      const SizedBox(height: 16),
                      CategoryLegend(fatias: fatias),
                    ],
                  );
                }
                return Row(
                  children: [
                    grafico,
                    const SizedBox(width: 22),
                    Expanded(child: CategoryLegend(fatias: fatias)),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
