import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tipo da transação: dinheiro que sai (despesa) ou que entra (receita).
enum TipoTransacao { despesa, receita }

/// Categorias disponíveis. Cada uma sabe a qual tipo pertence,
/// além do nome, ícone e cor usados na interface e nos gráficos.
enum Categoria {
  alimentacao(
    'Alimentação',
    Icons.restaurant_rounded,
    AppColors.orange,
    TipoTransacao.despesa,
  ),
  moradia(
    'Moradia',
    Icons.home_outlined,
    AppColors.blue,
    TipoTransacao.despesa,
  ),
  transporte(
    'Transporte',
    Icons.directions_car_outlined,
    AppColors.green,
    TipoTransacao.despesa,
  ),
  lazer(
    'Lazer',
    Icons.sports_esports_outlined,
    AppColors.purple,
    TipoTransacao.despesa,
  ),
  saude(
    'Saúde',
    Icons.favorite_border_rounded,
    AppColors.pink,
    TipoTransacao.despesa,
  ),
  educacao(
    'Educação',
    Icons.school_outlined,
    AppColors.cyan,
    TipoTransacao.despesa,
  ),
  compras(
    'Compras',
    Icons.shopping_bag_outlined,
    AppColors.yellow,
    TipoTransacao.despesa,
  ),
  contas(
    'Contas',
    Icons.receipt_long_outlined,
    AppColors.teal,
    TipoTransacao.despesa,
  ),
  outros(
    'Outros',
    Icons.more_horiz_rounded,
    AppColors.gray,
    TipoTransacao.despesa,
  ),

  salario(
    'Salário',
    Icons.account_balance_wallet_outlined,
    AppColors.green,
    TipoTransacao.receita,
  ),
  freelance(
    'Freelance',
    Icons.laptop_mac_outlined,
    AppColors.cyan,
    TipoTransacao.receita,
  ),
  investimentos(
    'Investimentos',
    Icons.trending_up_rounded,
    AppColors.blue,
    TipoTransacao.receita,
  ),
  outrasReceitas(
    'Outras receitas',
    Icons.attach_money_rounded,
    AppColors.gray,
    TipoTransacao.receita,
  );

  final String nome;
  final IconData icone;
  final Color cor;
  final TipoTransacao tipo;

  const Categoria(this.nome, this.icone, this.cor, this.tipo);

  /// Apenas as categorias de um determinado tipo.
  static List<Categoria> doTipo(TipoTransacao tipo) =>
      values.where((c) => c.tipo == tipo).toList();
}
