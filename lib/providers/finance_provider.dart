import 'package:flutter/material.dart';

import '../data/dados_exemplo.dart';
import '../models/resumos.dart';
import '../models/transacao.dart';

/// Filtro usado na lista de movimentações.
enum FiltroTransacao { todas, despesas, receitas }

/// Estado compartilhado do app. Guarda apenas a lista de transações (e
/// algumas preferências); todo o resto (saldo, totais, gráficos) é
/// calculado a partir dela, então Dashboard, Movimentações e Relatórios
/// ficam sempre sincronizados quando `notifyListeners()` é chamado.
class FinanceProvider extends ChangeNotifier {
  FinanceProvider({
    DateTime Function()? relogio,
    List<Transacao>? transacoesIniciais,
  }) : _relogio = relogio ?? DateTime.now {
    _transacoes.addAll(transacoesIniciais ?? gerarDadosExemplo(hoje));
  }

  /// Fonte da data atual (substituível nos testes).
  final DateTime Function() _relogio;
  final List<Transacao> _transacoes = [];

  FiltroTransacao _filtro = FiltroTransacao.todas;
  Periodo _periodoRelatorio = Periodo.mes;
  double _orcamentoMensal = 2500;

  /// Data de hoje (sem horário), segundo o relógio do provider.
  DateTime get hoje {
    final agora = _relogio();
    return DateTime(agora.year, agora.month, agora.day);
  }

  // ---------- Listas ----------

  /// Todas as transações, da mais recente para a mais antiga.
  List<Transacao> get transacoes {
    final lista = [..._transacoes]..sort((a, b) => b.data.compareTo(a.data));
    return List.unmodifiable(lista);
  }

  List<Transacao> get transacoesFiltradas {
    switch (_filtro) {
      case FiltroTransacao.despesas:
        return transacoes.where((t) => !t.isReceita).toList();
      case FiltroTransacao.receitas:
        return transacoes.where((t) => t.isReceita).toList();
      case FiltroTransacao.todas:
        return transacoes;
    }
  }

  List<Transacao> recentes([int quantidade = 5]) =>
      transacoes.take(quantidade).toList();

  FiltroTransacao get filtro => _filtro;
  Periodo get periodoRelatorio => _periodoRelatorio;
  double get orcamentoMensal => _orcamentoMensal;

  // ---------- Totais ----------

  /// Saldo de todas as transações registradas.
  double get saldo => _transacoes.fold(0.0, (s, t) => s + t.valorComSinal);

  /// Transações dentro de uma janela de [periodo] dias terminando hoje.
  /// [deslocamento] 1 devolve a janela imediatamente anterior.
  Iterable<Transacao> _naJanela(Periodo periodo, {int deslocamento = 0}) {
    final h = hoje;
    final fim = DateTime(
      h.year,
      h.month,
      h.day + 1 - periodo.dias * deslocamento,
    );
    final inicio = DateTime(fim.year, fim.month, fim.day - periodo.dias);
    return _transacoes.where(
      (t) => !t.data.isBefore(inicio) && t.data.isBefore(fim),
    );
  }

  static double _somaReceitas(Iterable<Transacao> lista) =>
      lista.where((t) => t.isReceita).fold(0.0, (s, t) => s + t.valor);

  static double _somaDespesas(Iterable<Transacao> lista) =>
      lista.where((t) => !t.isReceita).fold(0.0, (s, t) => s + t.valor);

  static double? _variacao(double atual, double anterior) {
    if (anterior == 0) return null;
    return (atual - anterior) / anterior.abs() * 100;
  }

  ResumoPeriodo resumo(Periodo periodo) {
    final atual = _naJanela(periodo).toList();
    final anterior = _naJanela(periodo, deslocamento: 1).toList();

    final receitas = _somaReceitas(atual);
    final despesas = _somaDespesas(atual);
    final receitasAnt = _somaReceitas(anterior);
    final despesasAnt = _somaDespesas(anterior);

    return ResumoPeriodo(
      receitas: receitas,
      despesas: despesas,
      mediaGastosDia: despesas / periodo.dias,
      variacaoReceitas: _variacao(receitas, receitasAnt),
      variacaoDespesas: _variacao(despesas, despesasAnt),
      variacaoSaldo: _variacao(receitas - despesas, receitasAnt - despesasAnt),
      variacaoMedia: _variacao(despesas, despesasAnt),
    );
  }

  /// Quanto o saldo total mudou (%) desde o início do período.
  double? variacaoSaldoTotal(Periodo periodo) {
    final noPeriodo = _naJanela(
      periodo,
    ).fold(0.0, (s, t) => s + t.valorComSinal);
    return _variacao(saldo, saldo - noPeriodo);
  }

  /// Gastos do período agrupados por categoria. Mostra no máximo
  /// [maxFatias]; o excedente (e a categoria "Outros") vira "Outros",
  /// sempre por último.
  List<FatiaCategoria> gastosPorCategoria(
    Periodo periodo, {
    int maxFatias = 6,
  }) {
    final totais = <Categoria, double>{};
    for (final t in _naJanela(periodo).where((t) => !t.isReceita)) {
      totais[t.categoria] = (totais[t.categoria] ?? 0) + t.valor;
    }
    final total = totais.values.fold(0.0, (s, v) => s + v);
    if (total == 0) return [];

    var outros = totais.remove(Categoria.outros) ?? 0;
    final ordenadas = totais.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final visiveis = ordenadas.take(maxFatias - 1).toList();
    for (final extra in ordenadas.skip(maxFatias - 1)) {
      outros += extra.value;
    }

    FatiaCategoria fatia(Categoria c, double valor) => FatiaCategoria(
      nome: c.nome,
      icone: c.icone,
      cor: c.cor,
      valor: valor,
      percentual: valor / total,
    );

    return [
      for (final e in visiveis) fatia(e.key, e.value),
      if (outros > 0) fatia(Categoria.outros, outros),
    ];
  }

  /// As maiores despesas individuais do período.
  List<Transacao> maioresGastos(Periodo periodo, {int quantidade = 3}) {
    final despesas = _naJanela(periodo).where((t) => !t.isReceita).toList()
      ..sort((a, b) => b.valor.compareTo(a.valor));
    return despesas.take(quantidade).toList();
  }

  // ---------- Ações (alteram o estado e notificam) ----------

  void adicionarTransacao({
    required double valor,
    required Categoria categoria,
    required DateTime data,
    required FormaPagamento formaPagamento,
    String? observacao,
  }) {
    // Mantém a hora atual para que, no mesmo dia, a transação recém-criada
    // apareça antes das demais.
    final agora = _relogio();
    _transacoes.add(
      Transacao(
        id: agora.microsecondsSinceEpoch.toString(),
        valor: valor,
        categoria: categoria,
        data: DateTime(
          data.year,
          data.month,
          data.day,
          agora.hour,
          agora.minute,
          agora.second,
        ),
        formaPagamento: formaPagamento,
        observacao: observacao,
      ),
    );
    notifyListeners();
  }

  void removerTransacao(Transacao transacao) {
    _transacoes.removeWhere((t) => t.id == transacao.id);
    notifyListeners();
  }

  /// Usado pelo botão "Desfazer" depois de excluir.
  void restaurarTransacao(Transacao transacao) {
    _transacoes.add(transacao);
    notifyListeners();
  }

  void alterarFiltro(FiltroTransacao novoFiltro) {
    if (_filtro == novoFiltro) return;
    _filtro = novoFiltro;
    notifyListeners();
  }

  void alterarPeriodoRelatorio(Periodo periodo) {
    if (_periodoRelatorio == periodo) return;
    _periodoRelatorio = periodo;
    notifyListeners();
  }

  void definirOrcamento(double valor) {
    _orcamentoMensal = valor;
    notifyListeners();
  }
}
