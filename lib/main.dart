import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/main_shell.dart';
import 'providers/finance_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // O provider fica acima do MaterialApp, então TODAS as telas
    // (Dashboard, Adicionar, Movimentações e Relatórios) acessam o mesmo estado.
    ChangeNotifierProvider(
      create: (_) => FinanceProvider(),
      child: const ControleGastosApp(),
    ),
  );
}

class ControleGastosApp extends StatelessWidget {
  const ControleGastosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Gastos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}
