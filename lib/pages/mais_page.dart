import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/resumos.dart';
import '../providers/finance_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../utils/valor_input_formatter.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_input.dart';
import '../widgets/header.dart';
import '../widgets/responsive_center.dart';

/// Perfil e preferências: orçamento mensal e informações do app.
class MaisPage extends StatelessWidget {
  const MaisPage({super.key});

  Future<void> _editarOrcamento(BuildContext context) async {
    final provider = context.read<FinanceProvider>();
    final controller = TextEditingController(
      text: formatarNumero(provider.orcamentoMensal),
    );

    final novoValor = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInput(
              label: 'Orçamento mensal',
              controller: controller,
              prefixText: 'R\$',
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [ValorInputFormatter()],
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Salvar',
              onPressed: () => Navigator.pop(
                ctx,
                ValorInputFormatter.lerValor(controller.text),
              ),
            ),
          ],
        ),
      ),
    );
    controller.dispose();

    if (novoValor != null && novoValor > 0) {
      provider.definirOrcamento(novoValor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final gasto = finance.resumo(Periodo.mes).despesas;
    final orcamento = finance.orcamentoMensal;
    final uso = orcamento == 0 ? 0.0 : gasto / orcamento;
    final estourou = gasto > orcamento;
    final corBarra = estourou
        ? AppColors.danger
        : uso > 0.8
        ? AppColors.orange
        : AppColors.primary;

    return SafeArea(
      bottom: false,
      child: ResponsiveCenter(
        maxWidth: ResponsiveCenter.larguraMedia,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            16,
            AppSpacing.page,
            32,
          ),
          children: [
            const AppHeader(title: 'Mais'),
            const SizedBox(height: 18),
            const AppCard(
              child: Row(
                children: [
                  ProfileAvatar(size: 52),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'João Victor',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Conta pessoal',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              onTap: () => _editarOrcamento(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Orçamento mensal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${formatarMoeda(gasto)} de ${formatarMoeda(orcamento)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: uso.clamp(0.0, 1.0),
                      minHeight: 8,
                      color: corBarra,
                      backgroundColor: AppColors.surfaceHigh,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    estourou
                        ? 'Você passou do orçamento em '
                              '${formatarMoeda(gasto - orcamento)} nos últimos 30 dias.'
                        : 'Ainda restam ${formatarMoeda(orcamento - gasto)} '
                              '(${formatarPercentual(uso)} usado nos últimos 30 dias).',
                    style: TextStyle(fontSize: 13, color: corBarra),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
