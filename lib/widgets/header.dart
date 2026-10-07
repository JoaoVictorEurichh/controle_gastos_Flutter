import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Cabeçalho das páginas principais: título grande, subtítulo opcional
/// e ações à direita.
class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        for (final acao in actions) ...[const SizedBox(width: 6), acao],
      ],
    );
  }
}

/// Barra superior das telas secundárias: voltar, título central e ação.
class AppTopBar extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const AppTopBar({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Voltar',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 48, child: trailing),
        ],
      ),
    );
  }
}

/// Sino de notificações com indicador vermelho.
class NotificationBell extends StatelessWidget {
  final bool hasUnread;
  final VoidCallback? onPressed;

  const NotificationBell({super.key, this.hasUnread = true, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Notificações',
      onPressed: onPressed,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none_rounded, size: 26),
          if (hasUnread)
            Positioned(
              right: 2,
              top: 1,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Avatar circular do usuário.
class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const ProfileAvatar({super.key, this.onTap, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: 'Perfil',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceHigh,
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Icon(
            Icons.person_rounded,
            size: size * 0.62,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
