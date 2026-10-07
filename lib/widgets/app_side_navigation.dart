import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_bottom_navigation.dart';
import 'app_button.dart';
import 'icon_badge.dart';

/// Menu lateral usado em telas largas (web/desktop) no lugar da
/// navegação inferior. Mesmas abas e mesmo botão de adicionar.
class AppSideNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  const AppSideNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        right: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconBadge(
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.primary,
                      size: 38,
                      filled: true,
                      circle: false,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Controle de Gastos',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'Adicionar',
                icon: Icons.add_rounded,
                onPressed: onAdd,
              ),
              const SizedBox(height: 20),
              for (var i = 0; i < appNavItems.length; i++)
                _SideItem(
                  item: appNavItems[i],
                  active: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  final AppNavItem item;
  final bool active;
  final VoidCallback onTap;

  const _SideItem({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = active ? AppColors.primary : AppColors.textSecondary;
    final borda = BorderRadius.circular(AppRadius.md);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        selected: active,
        button: true,
        child: Material(
          color: active
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: borda,
          child: InkWell(
            onTap: onTap,
            borderRadius: borda,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(active ? item.activeIcon : item.icon, color: cor),
                  const SizedBox(width: 14),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: active ? AppColors.textPrimary : cor,
                      fontSize: 14.5,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
