import 'package:controle_gastos/main.dart';
import 'package:controle_gastos/models/resumos.dart';
import 'package:controle_gastos/models/transacao.dart';
import 'package:controle_gastos/providers/finance_provider.dart';
import 'package:controle_gastos/utils/formatadores.dart';
import 'package:controle_gastos/utils/valor_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  final hoje = DateTime(2025, 9, 22, 10);
  FinanceProvider criarProvider() => FinanceProvider(relogio: () => hoje);

  group('FinanceProvider', () {
    test('dados de exemplo reproduzem os valores do design (30 dias)', () {
      final r = criarProvider().resumo(Periodo.mes);
      expect(r.receitas, closeTo(4200, 0.001));
      expect(r.despesas, closeTo(1640, 0.001));
      expect(r.saldo, closeTo(2560, 0.001));
      expect(r.mediaGastosDia, closeTo(54.67, 0.01));
    });

    test('gastos por categoria: até 6 fatias e "Outros" por último', () {
      final fatias = criarProvider().gastosPorCategoria(Periodo.mes);
      expect(fatias.map((f) => f.nome), [
        'Alimentação',
        'Moradia',
        'Transporte',
        'Lazer',
        'Saúde',
        'Outros',
      ]);
      expect(fatias.map((f) => formatarPercentual(f.percentual)), [
        '32%',
        '24%',
        '14%',
        '12%',
        '8%',
        '10%',
      ]);
    });

    test('adicionar despesa atualiza saldo, totais e categoria', () {
      final provider = criarProvider();
      var notificou = false;
      provider.addListener(() => notificou = true);
      final saldoAntes = provider.saldo;

      provider.adicionarTransacao(
        valor: 150,
        categoria: Categoria.educacao,
        data: hoje,
        formaPagamento: FormaPagamento.pix,
        observacao: 'Curso',
      );

      expect(notificou, isTrue);
      expect(provider.saldo, closeTo(saldoAntes - 150, 0.001));
      expect(provider.resumo(Periodo.mes).despesas, closeTo(1790, 0.001));
      expect(provider.recentes().first.titulo, 'Curso');
      expect(provider.recentes().first.formaPagamento, FormaPagamento.pix);
      // Educação entra no top 5 e o excedente vai para "Outros".
      expect(
        provider.gastosPorCategoria(Periodo.mes).map((f) => f.nome),
        contains('Educação'),
      );
    });

    test('adicionar receita aumenta receitas e saldo', () {
      final provider = criarProvider();
      provider.adicionarTransacao(
        valor: 500,
        categoria: Categoria.freelance,
        data: hoje,
        formaPagamento: FormaPagamento.pix,
      );
      expect(provider.resumo(Periodo.mes).receitas, closeTo(4700, 0.001));
      expect(provider.recentes().first.titulo, 'Freelance');
    });
  });

  group('Formatadores', () {
    test('moeda e variação', () {
      expect(formatarMoeda(2560), 'R\$ 2.560,00');
      expect(formatarMoeda(1640, centavos: false), 'R\$ 1.640');
      expect(formatarVariacao(12.3), '+12%');
      expect(formatarVariacao(-8), '-8%');
      expect(abreviarValor(2500), '2.5k');
    });

    test('máscara de valor preenche pelos centavos', () {
      final f = ValorInputFormatter();
      final r = f.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '123456'),
      );
      expect(r.text, '1.234,56');
      expect(ValorInputFormatter.lerValor(r.text), 1234.56);
    });
  });

  group('Telas', () {
    Future<void> abrirApp(WidgetTester tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => criarProvider(),
          child: const ControleGastosApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Dashboard mostra saudação e saldo', (tester) async {
      await abrirApp(tester);
      expect(find.text('Olá, João Victor'), findsOneWidget);
      expect(find.text('Saldo atual'), findsOneWidget);
      expect(find.text('R\$ 4.200,00'), findsOneWidget);
    });

    testWidgets('adicionar gasto aparece no Dashboard', (tester) async {
      await abrirApp(tester);

      await tester.tap(find.bySemanticsLabel('Adicionar movimentação'));
      await tester.pumpAndSettle();
      expect(find.text('Adicionar gasto'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, '5000');
      await tester.enterText(find.byType(TextField).last, 'Pizza');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('- R\$ 50,00'), findsOneWidget);
      expect(find.text('R\$ 1.690,00'), findsOneWidget);
    });

    testWidgets('salvar sem valor mostra erro', (tester) async {
      await abrirApp(tester);
      await tester.tap(find.bySemanticsLabel('Adicionar movimentação'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar'));
      await tester.pump();
      expect(find.text('Informe um valor maior que zero'), findsOneWidget);
    });

    testWidgets('aba Relatórios abre com 30 dias', (tester) async {
      await abrirApp(tester);
      await tester.tap(find.text('Relatórios'));
      await tester.pumpAndSettle();
      expect(find.text('Resumo do período'), findsOneWidget);
      expect(find.text('Média de gastos/dia'), findsOneWidget);
      expect(find.text('R\$ 54,67'), findsOneWidget);
    });
  });

  group('Responsividade', () {
    const tamanhos = {
      'celular pequeno': Size(320, 640),
      'celular': Size(390, 844),
      'tablet': Size(768, 1024),
      'notebook': Size(1280, 800),
      'full HD': Size(1920, 1080),
    };

    for (final MapEntry(key: nome, value: tamanho) in tamanhos.entries) {
      testWidgets('todas as telas sem overflow: $nome', (tester) async {
        tester.view.physicalSize = tamanho;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (_) => criarProvider(),
            child: const ControleGastosApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Menu lateral só em telas largas.
        final lateral = tamanho.width >= 960;
        expect(
          find.text('Adicionar'),
          lateral ? findsOneWidget : findsNothing,
        );

        // Percorre as abas; qualquer overflow faz o teste falhar.
        for (final aba in ['Gastos', 'Relatórios', 'Mais', 'Início']) {
          await tester.tap(find.text(aba).last);
          await tester.pumpAndSettle();
        }

        await tester.tap(
          lateral
              ? find.text('Adicionar')
              : find.bySemanticsLabel('Adicionar movimentação'),
        );
        await tester.pumpAndSettle();
        expect(find.text('Adicionar gasto'), findsOneWidget);
      });
    }
  });
}
