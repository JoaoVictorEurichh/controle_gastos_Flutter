import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transacao.dart';
import '../providers/finance_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'icon_badge.dart';

/// Mostra os detalhes de uma movimentação, com opção de excluir
/// (e desfazer pela snackbar).
Future<void> showTransactionDetails(BuildContext context, Transacao transacao) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _TransactionDetails(transacao: transacao),
  );
}

class _TransactionDetails extends StatelessWidget {
  final Transacao transacao;

  const _TransactionDetails({required this.transacao});

  void _excluir(BuildContext context) {
    final provider = context.read<FinanceProvider>();
    final messenger = ScaffoldMessenger.of(context);
    provider.removerTransacao(transacao);
    Navigator.pop(context);
    messenger
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
    final cor = transacao.isReceita ? AppColors.primary : AppColors.danger;
    final observacao = transacao.observacao?.trim() ?? '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBadge(
              icon: transacao.categoria.icone,
              color: transacao.categoria.cor,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              transacao.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              '${transacao.isReceita ? '+' : '-'} ${formatarMoeda(transacao.valor)}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: cor,
              ),
            ),
            const SizedBox(height: 20),
            _Linha('Tipo', transacao.isReceita ? 'Receita' : 'Despesa'),
            _Linha('Categoria', transacao.categoria.nome),
            _Linha('Data', formatarData(transacao.data)),
            _Linha('Pagamento', transacao.formaPagamento.nome),
            if (observacao.isNotEmpty) _Linha('Observações', observacao),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _excluir(context),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Excluir movimentação'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: BorderSide(
                    color: AppColors.danger.withValues(alpha: 0.5),
                  ),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _Linha(this.rotulo, this.valor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
