import 'package:flutter/material.dart';

import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_side_navigation.dart';
import '../widgets/responsive_center.dart';
import 'adicionar_transacao_page.dart';
import 'dashboard_page.dart';
import 'mais_page.dart';
import 'relatorios_page.dart';
import 'transacoes_page.dart';

/// Estrutura principal: navegação inferior no celular/tablet e menu
/// lateral em telas largas. As abas ficam num IndexedStack para manter
/// a posição de rolagem de cada uma.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _abaGastos = 1;
  static const _abaMais = 3;

  int _aba = 0;

  // Mantém o estado das abas (rolagem etc.) ao alternar entre barra
  // inferior e menu lateral quando a janela é redimensionada.
  final _paginasKey = GlobalKey();

  void _irPara(int aba) => setState(() => _aba = aba);

  void _adicionar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarTransacaoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lateral =
        MediaQuery.sizeOf(context).width >= Breakpoints.navegacaoLateral;

    final paginas = IndexedStack(
      key: _paginasKey,
      index: _aba,
      children: [
        DashboardPage(
          onVerTodas: () => _irPara(_abaGastos),
          onPerfil: () => _irPara(_abaMais),
        ),
        const TransacoesPage(),
        const RelatoriosPage(),
        const MaisPage(),
      ],
    );

    if (lateral) {
      return Scaffold(
        body: Row(
          children: [
            AppSideNavigation(
              currentIndex: _aba,
              onTap: _irPara,
              onAdd: _adicionar,
            ),
            Expanded(child: paginas),
          ],
        ),
      );
    }

    return Scaffold(
      body: paginas,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _aba,
        onTap: _irPara,
        onAdd: _adicionar,
      ),
    );
  }
}
