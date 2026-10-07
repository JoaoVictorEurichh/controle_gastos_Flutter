import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/resumos.dart';
import '../providers/finance_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../widgets/app_card.dart';
import '../widgets/balance_card.dart';
import '../widgets/charts/category_donut_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/header.dart';
import '../widgets/responsive_center.dart';
import '../widgets/section_header.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_details_sheet.dart';
import '../widgets/transaction_item.dart';

/// Tela inicial: saldo, receitas/despesas, movimentações recentes e
/// gastos por categoria dos últimos 30 dias.
class DashboardPage extends StatelessWidget {
  final VoidCallback onVerTodas;
  final VoidCallback onPerfil;

  const DashboardPage({
    super.key,
    required this.onVerTodas,
    required this.onPerfil,
  });

  static const _periodo = Periodo.mes;

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final resumo = finance.resumo(_periodo);
    // Barra do saldo: quanto da receita do período ainda sobrou.
    final progresso = resumo.receitas == 0
        ? 0.0
        : resumo.saldo / resumo.receitas;

    final saldoECartoes = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BalanceCard(
          saldo: finance.saldo,
          variacao: finance.variacaoSaldoTotal(_periodo),
          variacaoLegenda: 'em 30 dias',
          progresso: progresso,
        ),
        const SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 120,
          maxColumns: 2,
          children: [
            HighlightSummaryCard(
              icon: Icons.arrow_upward_rounded,
              color: AppColors.primary,
              label: 'Receitas',
              value: formatarMoeda(resumo.receitas),
              caption: 'últimos 30 dias',
            ),
            HighlightSummaryCard(
              icon: Icons.arrow_downward_rounded,
              color: AppColors.danger,
              label: 'Despesas',
              value: formatarMoeda(resumo.despesas),
              valueColor: AppColors.danger,
              caption: 'últimos 30 dias',
            ),
          ],
        ),
      ],
    );

    final graficoCategorias = CategoryDonutCard(
      title: 'Resumo do mês',
      fatias: finance.gastosPorCategoria(_periodo),
      centerValue: formatarMoeda(resumo.despesas, centavos: false),
      centerLabel: 'despesas',
    );

    Widget movimentacoes(int quantidade) {
      final recentes = finance.recentes(quantidade);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Movimentações recentes',
            actionLabel: 'Ver todas',
            onAction: onVerTodas,
          ),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: recentes.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    message:
                        'Nenhuma movimentação ainda.\n'
                        'Toque em + para adicionar.',
                  )
                : Column(
                    children: [
                      for (var i = 0; i < recentes.length; i++) ...[
                        if (i > 0)
                          const Divider(height: 1, color: AppColors.border),
                        TransactionItem(
                          transacao: recentes[i],
                          onTap: () =>
                              showTransactionDetails(context, recentes[i]),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      );
    }

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
            AppHeader(
              title: 'Olá, João Victor',
              subtitle: 'Aqui está um resumo das suas finanças.',
              actions: [
                NotificationBell(
                  onPressed: () => ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Você não tem novas notificações.'),
                      ),
                    ),
                ),
                ProfileAvatar(onTap: onPerfil),
              ],
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                // Telas largas: resumo e gráfico à esquerda, lista à direita.
                if (constraints.maxWidth >= Breakpoints.duasColunas) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            saldoECartoes,
                            const SizedBox(height: AppSpacing.lg),
                            graficoCategorias,
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Ao lado do saldo sobra altura: mostra mais itens.
                      Expanded(child: movimentacoes(8)),
                    ],
                  );
                }
                // Celular: mesma ordem do design.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    saldoECartoes,
                    const SizedBox(height: 26),
                    movimentacoes(5),
                    const SizedBox(height: AppSpacing.lg),
                    graficoCategorias,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
