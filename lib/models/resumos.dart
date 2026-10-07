import 'package:flutter/material.dart';

/// Intervalo usado nos relatórios (sempre contando a partir de hoje).
enum Periodo {
  semana(7, '7 dias'),
  mes(30, '30 dias'),
  trimestre(90, '3 meses'),
  ano(365, '1 ano');

  final int dias;
  final String rotulo;

  const Periodo(this.dias, this.rotulo);
}

/// Totais de um período comparados com o período anterior de mesmo tamanho.
/// As variações são percentuais (ex.: 12.0 = +12%) e ficam nulas quando
/// não há base de comparação.
class ResumoPeriodo {
  final double receitas;
  final double despesas;
  final double mediaGastosDia;
  final double? variacaoReceitas;
  final double? variacaoDespesas;
  final double? variacaoSaldo;
  final double? variacaoMedia;

  const ResumoPeriodo({
    required this.receitas,
    required this.despesas,
    required this.mediaGastosDia,
    this.variacaoReceitas,
    this.variacaoDespesas,
    this.variacaoSaldo,
    this.variacaoMedia,
  });

  double get saldo => receitas - despesas;
}

/// Uma fatia do gráfico de gastos por categoria.
class FatiaCategoria {
  final String nome;
  final IconData icone;
  final Color cor;
  final double valor;

  /// Entre 0 e 1.
  final double percentual;

  const FatiaCategoria({
    required this.nome,
    required this.icone,
    required this.cor,
    required this.valor,
    required this.percentual,
  });
}
