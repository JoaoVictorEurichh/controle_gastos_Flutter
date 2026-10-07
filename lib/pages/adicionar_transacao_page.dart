import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transacao.dart';
import '../providers/finance_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../utils/valor_input_formatter.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../widgets/app_select.dart';
import '../widgets/category_selector.dart';
import '../widgets/header.dart';
import '../widgets/icon_badge.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/responsive_center.dart';
import '../widgets/segmented_toggle.dart';
import 'transacoes_page.dart';

/// Formulário para adicionar uma despesa ou receita. O estado do
/// formulário é local; ao salvar, a transação vai para o FinanceProvider
/// e aparece no Dashboard, em Movimentações e nos Relatórios.
class AdicionarTransacaoPage extends StatefulWidget {
  const AdicionarTransacaoPage({super.key});

  @override
  State<AdicionarTransacaoPage> createState() => _AdicionarTransacaoPageState();
}

class _AdicionarTransacaoPageState extends State<AdicionarTransacaoPage> {
  final _valorController = TextEditingController();
  final _observacaoController = TextEditingController();

  TipoTransacao _tipo = TipoTransacao.despesa;
  Categoria _categoria = Categoria.alimentacao;
  FormaPagamento _forma = FormaPagamento.cartaoCredito;
  late DateTime _data = context.read<FinanceProvider>().hoje;
  String? _erroValor;

  bool get _isDespesa => _tipo == TipoTransacao.despesa;

  @override
  void dispose() {
    _valorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _trocarTipo(TipoTransacao tipo) {
    if (tipo == _tipo) return;
    setState(() {
      _tipo = tipo;
      _categoria = Categoria.doTipo(tipo).first;
      _forma = _isDespesa ? FormaPagamento.cartaoCredito : FormaPagamento.pix;
    });
  }

  Future<void> _escolherCategoria() async {
    final escolhida = await showCategorySelector(
      context,
      tipo: _tipo,
      selecionada: _categoria,
    );
    if (escolhida != null) setState(() => _categoria = escolhida);
  }

  Future<void> _escolherData() async {
    final hoje = context.read<FinanceProvider>().hoje;
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(hoje.year - 5),
      lastDate: hoje,
    );
    if (escolhida != null) setState(() => _data = escolhida);
  }

  Future<void> _escolherForma() async {
    final escolhida = await showPaymentMethodSelector(
      context,
      selecionada: _forma,
    );
    if (escolhida != null) setState(() => _forma = escolhida);
  }

  void _salvar() {
    final valor = ValorInputFormatter.lerValor(_valorController.text);
    if (valor <= 0) {
      setState(() => _erroValor = 'Informe um valor maior que zero');
      return;
    }

    context.read<FinanceProvider>().adicionarTransacao(
      valor: valor,
      categoria: _categoria,
      data: _data,
      formaPagamento: _forma,
      observacao: _observacaoController.text.trim(),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${_isDespesa ? 'Despesa' : 'Receita'} de '
            '${formatarMoeda(valor)} adicionada!',
          ),
        ),
      );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppTopBar(
                  title: _isDespesa ? 'Adicionar gasto' : 'Adicionar receita',
                  trailing: IconButton(
                    tooltip: 'Ver movimentações',
                    icon: const Icon(Icons.receipt_long_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Scaffold(
                          body: TransacoesPage(mostrarVoltar: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    12,
                    AppSpacing.page,
                    24,
                  ),
                  children: [
                    SegmentedToggle<TipoTransacao>(
                      height: 50,
                      selected: _tipo,
                      onChanged: _trocarTipo,
                      options: const [
                        SegmentOption(
                          TipoTransacao.despesa,
                          'Despesa',
                          icon: Icons.arrow_downward_rounded,
                        ),
                        SegmentOption(
                          TipoTransacao.receita,
                          'Receita',
                          icon: Icons.arrow_upward_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    AppInput(
                      label: 'Valor',
                      controller: _valorController,
                      prefixText: 'R\$',
                      hint: '0,00',
                      errorText: _erroValor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ValorInputFormatter()],
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textMuted,
                      ),
                      onChanged: (_) {
                        if (_erroValor != null) {
                          setState(() => _erroValor = null);
                        }
                      },
                    ),
                    const SizedBox(height: 22),
                    AppSelect(
                      label: 'Categoria',
                      value: _categoria.nome,
                      onTap: _escolherCategoria,
                      leading: IconBadge(
                        icon: _categoria.icone,
                        color: _categoria.cor,
                        size: 42,
                        filled: true,
                        circle: false,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppSelect(
                      label: 'Data',
                      value: formatarData(_data),
                      onTap: _escolherData,
                      leading: const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppSelect(
                      label: _isDespesa
                          ? 'Forma de pagamento'
                          : 'Forma de recebimento',
                      value: _forma.nome,
                      onTap: _escolherForma,
                      leading: Icon(
                        _forma.icone,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppInput(
                      label: 'Observações',
                      optional: true,
                      controller: _observacaoController,
                      hint: _isDespesa
                          ? 'Ex: Almoço com amigos...'
                          : 'Ex: Salário de setembro...',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  8,
                  AppSpacing.page,
                  16,
                ),
                child: AppButton(
                  label: 'Salvar',
                  icon: Icons.save_outlined,
                  onPressed: _salvar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
