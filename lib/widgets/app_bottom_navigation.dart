import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'responsive_center.dart';

/// Destino da navegação principal (barra inferior ou menu lateral).
class AppNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppNavItem(this.icon, this.activeIcon, this.label);
}

/// Abas do app, na ordem dos índices usados pelo MainShell.
const appNavItems = [
  AppNavItem(Icons.home_outlined, Icons.home_rounded, 'Início'),
  AppNavItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Gastos'),
  AppNavItem(Icons.bar_chart_rounded, Icons.bar_chart_rounded, 'Relatórios'),
  AppNavItem(Icons.more_horiz_rounded, Icons.more_horiz_rounded, 'Mais'),
];

/// Navegação inferior: Início, Gastos, (+), Relatórios, Mais.
/// O botão "+" é maior, verde e fica elevado acima da barra.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAdd,
  });

  Widget _item(int index) => Expanded(
    child: _NavButton(
      item: appNavItems[index],
      active: currentIndex == index,
      onTap: () => onTap(index),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        // Limita o zoom de texto para os rótulos caberem na barra.
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.2,
          child: ResponsiveCenter(
            shrinkHeight: true,
            child: SizedBox(
              height: 66,
              child: Row(
                children: [
                  _item(0),
                  _item(1),
                  Expanded(
                    child: Center(child: _AddButton(onTap: onAdd)),
                  ),
                  _item(2),
                  _item(3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final AppNavItem item;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = active ? AppColors.primary : AppColors.textSecondary;
    return Semantics(
      selected: active,
      button: true,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? item.activeIcon : item.icon, color: cor, size: 25),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: cor,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Sobe metade do botão acima da barra.
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.background, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
            ),
          ],
        ),
        child: Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: const Icon(
              Icons.add_rounded,
              size: 30,
              color: AppColors.onPrimary,
              semanticLabel: 'Adicionar movimentação',
            ),
          ),
        ),
      ),
    );
  }
}
