import 'package:flutter/material.dart';

import '../../models/resumos.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatadores.dart';

/// Legenda do gráfico de rosca: bolinha colorida, nome e percentual.
class CategoryLegend extends StatelessWidget {
  final List<FatiaCategoria> fatias;

  const CategoryLegend({super.key, required this.fatias});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final fatia in fatias)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.5),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: fatia.cor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fatia.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  formatarPercentual(fatia.percentual),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
