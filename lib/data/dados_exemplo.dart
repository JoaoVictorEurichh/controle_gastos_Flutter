import '../models/transacao.dart';

/// Transações fictícias para o app não abrir vazio.
/// As datas são relativas a [hoje]: os últimos 30 dias reproduzem os
/// valores do design (receitas R$ 4.200,00 e despesas R$ 1.640,00) e
/// os meses anteriores alimentam o gráfico de evolução mensal.
List<Transacao> gerarDadosExemplo(DateTime hoje) {
  var sequencia = 0;
  final lista = <Transacao>[];

  void add(
    int diasAtras,
    String nome,
    double valor,
    Categoria categoria,
    FormaPagamento forma,
  ) {
    lista.add(
      Transacao(
        id: 'exemplo-${sequencia++}',
        valor: valor,
        categoria: categoria,
        data: DateTime(hoje.year, hoje.month, hoje.day - diasAtras),
        formaPagamento: forma,
        observacao: nome,
      ),
    );
  }

  // ----- Últimos 30 dias -----
  add(
    1,
    'Supermercado',
    415.20,
    Categoria.alimentacao,
    FormaPagamento.cartaoCredito,
  );
  add(3, 'Salário', 4200, Categoria.salario, FormaPagamento.pix);
  add(
    5,
    'Posto de combustível',
    180,
    Categoria.transporte,
    FormaPagamento.cartaoCredito,
  );
  add(6, 'Academia', 89.90, Categoria.saude, FormaPagamento.cartaoDebito);
  add(8, 'Internet', 99.90, Categoria.contas, FormaPagamento.boleto);
  add(10, 'Condomínio', 393.60, Categoria.moradia, FormaPagamento.boleto);
  add(
    12,
    'Restaurante',
    109.60,
    Categoria.alimentacao,
    FormaPagamento.cartaoCredito,
  );
  add(14, 'Cinema', 76.80, Categoria.lazer, FormaPagamento.cartaoCredito);
  add(17, 'Uber', 49.60, Categoria.transporte, FormaPagamento.cartaoCredito);
  add(19, 'Show', 120, Categoria.lazer, FormaPagamento.pix);
  add(22, 'Farmácia', 41.30, Categoria.saude, FormaPagamento.cartaoDebito);
  add(25, 'Presente', 64.10, Categoria.outros, FormaPagamento.pix);

  // ----- Blocos de 30 dias anteriores -----
  const salarios = [3750.0, 3900.0, 3600.0, 3450.0, 3500.0, 3300.0];
  const fatores = [1.0, 1.32, 1.12, 1.45, 1.2, 1.38];
  double escala(double valor, double fator) =>
      (valor * fator * 100).roundToDouble() / 100;

  for (var bloco = 1; bloco <= salarios.length; bloco++) {
    final base = 30 * bloco;
    final f = fatores[bloco - 1];

    add(
      base + 3,
      'Salário',
      salarios[bloco - 1],
      Categoria.salario,
      FormaPagamento.pix,
    );
    if (bloco.isEven) {
      add(
        base + 15,
        'Projeto freelance',
        650,
        Categoria.freelance,
        FormaPagamento.pix,
      );
    }
    add(
      base + 1,
      'Supermercado',
      escala(480, f),
      Categoria.alimentacao,
      FormaPagamento.cartaoCredito,
    );
    add(
      base + 5,
      'Posto de combustível',
      escala(210, f),
      Categoria.transporte,
      FormaPagamento.cartaoCredito,
    );
    add(base + 8, 'Internet', 99.90, Categoria.contas, FormaPagamento.boleto);
    add(
      base + 10,
      'Condomínio',
      393.60,
      Categoria.moradia,
      FormaPagamento.boleto,
    );
    add(
      base + 12,
      'Restaurante',
      escala(150, f),
      Categoria.alimentacao,
      FormaPagamento.cartaoCredito,
    );
    add(
      base + 14,
      'Passeio',
      escala(249.10, f),
      Categoria.lazer,
      FormaPagamento.pix,
    );
    add(
      base + 22,
      'Farmácia',
      escala(200, f),
      Categoria.saude,
      FormaPagamento.cartaoDebito,
    );
  }

  return lista;
}
