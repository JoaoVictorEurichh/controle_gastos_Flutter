import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/resumos.dart';
import '../models/transacao.dart';
import '../providers/finance_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../widgets/app_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/header.dart';
import '../widgets/icon_badge.dart';
import '../widgets/responsive_center.dart';
import '../widgets/segmented_toggle.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_details_sheet.dart';

/// Relatórios do período escolhido: resumo e maiores gastos.
/// Lê os mesmos dados do Dashboard.
class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final periodo = finance.periodoRelatorio;
    final resumo = finance.resumo(periodo);

    return SafeArea(
      bottom: false,
      child: ResponsiveCenter(
        maxWidth: ResponsiveCenter.larguraAmpla,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            16,
            AppSpacing.page,
            32,
          ),
          children: [
            const AppHeader(title: 'Relatórios'),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: ResponsiveCenter.larguraEstreita,
                ),
                child: SegmentedToggle<Periodo>(
                  selected: periodo,
                  selectedForeground: AppColors.onPrimary,
                  onChanged: context
                      .read<FinanceProvider>()
                      .alterarPeriodoRelatorio,
                  options: [
                    for (final p in Periodo.values) SegmentOption(p, p.rotulo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Resumo do período',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            ResponsiveGrid(
              minItemWidth: 150,
              children: [
                SummaryCard(
                  icon: Icons.arrow_upward_rounded,
                  iconColor: AppColors.primary,
                  label: 'Receitas',
                  value: formatarMoeda(resumo.receitas),
                  variacao: resumo.variacaoReceitas,
                ),
                SummaryCard(
                  icon: Icons.arrow_downward_rounded,
                  iconColor: AppColors.danger,
                  label: 'Despesas',
                  value: formatarMoeda(resumo.despesas),
                  valueColor: AppColors.danger,
                  variacao: resumo.variacaoDespesas,
                ),
                SummaryCard(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.primary,
                  label: 'Saldo',
                  value: formatarMoeda(resumo.saldo),
                  variacao: resumo.variacaoSaldo,
                ),
                SummaryCard(
                  icon: Icons.calendar_month_outlined,
                  iconColor: AppColors.textSecondary,
                  label: 'Média de gastos/dia',
                  value: formatarMoeda(resumo.mediaGastosDia),
                  variacao: resumo.variacaoMedia,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _MaioresGastos(
              gastos: finance.maioresGastos(periodo),
              totalDespesas: resumo.despesas,
            ),
          ],
        ),
      ),
    );
  }
}

class _MaioresGastos extends StatelessWidget {
  final List<Transacao> gastos;
  final double totalDespesas;

  const _MaioresGastos({required this.gastos, required this.totalDespesas});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Maiores gastos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          if (gastos.isEmpty)
            const EmptyState(
              icon: Icons.trending_down_rounded,
              message: 'Nenhum gasto no período.',
            ),
          for (final gasto in gastos)
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => showTransactionDetails(context, gasto),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    IconBadge(
                      icon: gasto.categoria.icone,
                      color: gasto.categoria.cor,
                      size: 36,
                      circle: false,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        gasto.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      formatarMoeda(gasto.valor),
                      style: const TextStyle(fontSize: 13.5),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        totalDespesas == 0
                            ? '—'
                            : formatarPercentual(gasto.valor / totalDespesas),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
