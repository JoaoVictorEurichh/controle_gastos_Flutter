import 'package:flutter/material.dart';

import '../models/forma_pagamento.dart';
import '../theme/app_colors.dart';

/// Abre a lista de formas de pagamento e devolve a escolhida.
Future<FormaPagamento?> showPaymentMethodSelector(
  BuildContext context, {
  FormaPagamento? selecionada,
}) {
  return showModalBottomSheet<FormaPagamento>(
    context: context,
    isScrollControlled: true,
    builder: (_) => PaymentMethodSelector(selecionada: selecionada),
  );
}

class PaymentMethodSelector extends StatelessWidget {
  final FormaPagamento? selecionada;

  const PaymentMethodSelector({super.key, this.selecionada});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                'Forma de pagamento',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            for (final forma in FormaPagamento.values)
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                leading: Icon(forma.icone, color: AppColors.textSecondary),
                title: Text(forma.nome),
                trailing: forma == selecionada
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                selected: forma == selecionada,
                selectedColor: AppColors.textPrimary,
                selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                onTap: () => Navigator.pop(context, forma),
              ),
          ],
        ),
      ),
    );
  }
}
