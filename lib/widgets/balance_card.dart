import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'app_card.dart';
import 'summary_card.dart';

/// Cartão grande de saldo do Dashboard. O olho esconde/mostra o valor.
class BalanceCard extends StatefulWidget {
  final double saldo;
  final double? variacao;
  final String variacaoLegenda;

  /// Preenchimento da barra (0 a 1).
  final double progresso;

  const BalanceCard({
    super.key,
    required this.saldo,
    required this.progresso,
    required this.variacaoLegenda,
    this.variacao,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _visivel = true;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Saldo atual',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkResponse(
                          radius: 18,
                          onTap: () => setState(() => _visivel = !_visivel),
                          child: Icon(
                            _visivel
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: AppColors.textSecondary,
                            semanticLabel: _visivel
                                ? 'Ocultar saldo'
                                : 'Mostrar saldo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _visivel ? formatarMoeda(widget.saldo) : 'R\$ ••••••',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.variacao != null)
                Padding(
                  padding: const EdgeInsets.only(top: 22, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      VariationText(
                        widget.variacao,
                        fontSize: 13,
                        showArrow: true,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.variacaoLegenda,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: widget.progresso.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (_, valor, _) => LinearProgressIndicator(
                value: valor,
                minHeight: 8,
                color: AppColors.primary,
                backgroundColor: AppColors.surfaceHigh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
