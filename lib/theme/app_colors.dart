import 'package:flutter/material.dart';

/// Paleta do app. Tema escuro: fundo grafite, cartões um pouco mais
/// claros, verde para ações/receitas e vermelho para despesas.
abstract final class AppColors {
  static const background = Color(0xFF0A0D12);
  static const surface = Color(0xFF12171E);
  static const surfaceHigh = Color(0xFF1A212B);
  static const border = Color(0xFF232B36);

  static const primary = Color(0xFF2FD07A);
  static const onPrimary = Color(0xFF05130B);
  static const danger = Color(0xFFFF4D67);

  static const textPrimary = Color(0xFFF2F4F7);
  static const textSecondary = Color(0xFF8B95A5);
  static const textMuted = Color(0xFF5D6675);

  // Cores das categorias (gráficos e ícones).
  static const orange = Color(0xFFFF9F43);
  static const blue = Color(0xFF3B82F6);
  static const green = Color(0xFF22C55E);
  static const purple = Color(0xFF8B5CF6);
  static const pink = Color(0xFFF43F5E);
  static const gray = Color(0xFF7A8494);
  static const cyan = Color(0xFF22B8CF);
  static const yellow = Color(0xFFF5C542);
  static const teal = Color(0xFF14B8A6);
}

/// Raios de borda usados em todo o app.
abstract final class AppRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
}

/// Espaçamentos padrão.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;

  /// Margem lateral das páginas.
  static const page = 20.0;
}
