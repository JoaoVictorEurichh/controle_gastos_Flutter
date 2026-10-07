import 'categoria.dart';
import 'forma_pagamento.dart';

export 'categoria.dart';
export 'forma_pagamento.dart';

class Transacao {
  final String id;
  final double valor;
  final Categoria categoria;
  final DateTime data;
  final FormaPagamento formaPagamento;
  final String? observacao;

  const Transacao({
    required this.id,
    required this.valor,
    required this.categoria,
    required this.data,
    required this.formaPagamento,
    this.observacao,
  });

  TipoTransacao get tipo => categoria.tipo;
  bool get isReceita => tipo == TipoTransacao.receita;

  /// Valor com sinal: positivo para receitas, negativo para despesas.
  double get valorComSinal => isReceita ? valor : -valor;

  /// Título exibido nas listas: a observação ou, se vazia, a categoria.
  String get titulo {
    final texto = observacao?.trim() ?? '';
    return texto.isEmpty ? categoria.nome : texto;
  }
}
