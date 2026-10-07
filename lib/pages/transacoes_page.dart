import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transacao.dart';
import '../providers/finance_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/header.dart';
import '../widgets/responsive_center.dart';
import '../widgets/segmented_toggle.dart';
import '../widgets/transaction_details_sheet.dart';
import '../widgets/transaction_item.dart';

/// Lista completa de movimentações, com filtro e exclusão por arraste
/// (com "Desfazer").
class TransacoesPage extends StatelessWidget {
  /// Quando aberta fora da navegação inferior, mostra a barra com voltar.
  final bool mostrarVoltar;

  const TransacoesPage({super.key, this.mostrarVoltar = false});

  void _excluir(BuildContext context, Transacao transacao) {
    final provider = context.read<FinanceProvider>();
    provider.removerTransacao(transacao);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${transacao.titulo}" excluída'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => provider.restaurarTransacao(transacao),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final lista = finance.transacoesFiltradas;

    return SafeArea(
      bottom: mostrarVoltar,
      child: ResponsiveCenter(
        maxWidth: ResponsiveCenter.larguraMedia,
        child: Column(
          children: [
            if (mostrarVoltar)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: AppTopBar(title: 'Movimentações'),
              ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  mostrarVoltar ? 4 : 16,
                  AppSpacing.page,
                  32,
                ),
                children: [
                  if (!mostrarVoltar) ...[
                    AppHeader(
                      title: 'Movimentações',
                      subtitle:
                          '${finance.transacoes.length} registros • '
                          'arraste para excluir',
                    ),
                    const SizedBox(height: 18),
                  ],
                  SegmentedToggle<FiltroTransacao>(
                    selected: finance.filtro,
                    onChanged: context.read<FinanceProvider>().alterarFiltro,
                    options: const [
                      SegmentOption(FiltroTransacao.todas, 'Todas'),
                      SegmentOption(FiltroTransacao.despesas, 'Despesas'),
                      SegmentOption(FiltroTransacao.receitas, 'Receitas'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: lista.isEmpty
                        ? const EmptyState(
                            icon: Icons.receipt_long_outlined,
                            message: 'Nenhuma movimentação por aqui.',
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < lista.length; i++) ...[
                                if (i > 0)
                                  const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                _ItemDeslizavel(
                                  transacao: lista[i],
                                  onExcluir: () => _excluir(context, lista[i]),
                                ),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemDeslizavel extends StatelessWidget {
  final Transacao transacao;
  final VoidCallback onExcluir;

  const _ItemDeslizavel({required this.transacao, required this.onExcluir});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(transacao.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.danger,
        ),
      ),
      onDismissed: (_) => onExcluir(),
      child: TransactionItem(
        transacao: transacao,
        onTap: () => showTransactionDetails(context, transacao),
      ),
    );
  }
}
