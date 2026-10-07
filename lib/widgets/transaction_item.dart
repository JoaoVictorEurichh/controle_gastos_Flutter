import 'package:flutter/material.dart';

import '../models/transacao.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'icon_badge.dart';

/// Linha de movimentação: ícone da categoria, título, data • forma de
/// pagamento e valor (verde para receita, vermelho para despesa).
class TransactionItem extends StatelessWidget {
  final Transacao transacao;
  final VoidCallback? onTap;

  const TransactionItem({super.key, required this.transacao, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cor = transacao.isReceita ? AppColors.primary : AppColors.danger;
    final sinal = transacao.isReceita ? '+' : '-';

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
            child: Row(
              children: [
                IconBadge(
                  icon: transacao.categoria.icone,
                  color: transacao.categoria.cor,
                  size: 40,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transacao.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${formatarData(transacao.data)} • '
                        '${transacao.formaPagamento.nomeCurto}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Em telas muito estreitas o valor encolhe em vez de estourar.
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: largura * 0.42),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$sinal ${formatarMoeda(transacao.valor)}',
                      style: TextStyle(
                        color: cor,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
