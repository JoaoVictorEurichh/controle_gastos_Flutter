import 'package:flutter/material.dart';

/// Como a transação foi paga/recebida.
enum FormaPagamento {
  pix('Pix', Icons.pix),
  dinheiro('Dinheiro', Icons.payments_outlined),
  cartaoDebito('Cartão de débito', Icons.credit_card_outlined, 'Débito'),
  cartaoCredito('Cartão de crédito', Icons.credit_card_outlined, 'Crédito'),
  boleto('Boleto', Icons.receipt_outlined),
  outro('Outro', Icons.more_horiz_rounded);

  final String nome;
  final IconData icone;
  final String? _nomeCurto;

  const FormaPagamento(this.nome, this.icone, [this._nomeCurto]);

  /// Versão curta para listas (ex.: "Crédito").
  String get nomeCurto => _nomeCurto ?? nome;
}
