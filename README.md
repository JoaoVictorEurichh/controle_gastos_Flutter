# 💰 Controle de Gastos

App em Flutter para controlar receitas e despesas. Projeto individual da disciplina, usando **Provider** para gerenciar o estado.

## Telas

- **Início**: saldo atual, receitas e despesas dos últimos 30 dias, movimentações recentes e gastos por categoria.
- **Gastos**: todas as movimentações, com filtro (Todas / Despesas / Receitas). Arraste um item para excluir.
- **Adicionar (+)**: cadastra uma despesa ou receita com valor, categoria, data, forma de pagamento e observações.
- **Relatórios**: resumo do período (7 dias, 30 dias, 3 meses ou 1 ano) e maiores gastos.
- **Mais**: perfil e orçamento mensal.

O app abre com dados de exemplo e se adapta a celular, tablet e computador.

## Provider

O `FinanceProvider` guarda a lista de transações e fica acima do `MaterialApp`, então todas as telas usam os mesmos dados. Saldo, totais e relatórios são calculados a partir dessa lista: ao adicionar ou excluir uma movimentação, todas as telas atualizam juntas.

## Como executar

```bash
flutter pub get
flutter run
```

Testes:

```bash
flutter test
```
