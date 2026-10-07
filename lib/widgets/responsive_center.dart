import 'package:flutter/material.dart';

/// Larguras de referência do layout.
abstract final class Breakpoints {
  /// A partir daqui a navegação inferior vira menu lateral.
  static const navegacaoLateral = 960.0;

  /// Largura de conteúdo a partir da qual as páginas usam duas colunas.
  static const duasColunas = 860.0;
}

/// Limita a largura do conteúdo e o centraliza, para o layout não
/// "esticar" em telas grandes.
class ResponsiveCenter extends StatelessWidget {
  /// Formulários e listas simples.
  static const larguraEstreita = 560.0;

  /// Listas e configurações.
  static const larguraMedia = 760.0;

  /// Páginas com grade/duas colunas (Dashboard, Relatórios).
  static const larguraAmpla = 1180.0;

  final Widget child;
  final double maxWidth;

  /// Usa só a altura do filho (ex.: barra inferior) em vez de ocupar
  /// todo o espaço disponível.
  final bool shrinkHeight;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = larguraEstreita,
    this.shrinkHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: shrinkHeight ? 1 : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Grade que escolhe o número de colunas pela largura disponível.
/// Itens de uma mesma linha ficam com a mesma altura.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.minItemWidth,
    this.maxColumns = 4,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cabem =
            ((constraints.maxWidth + spacing) / (minItemWidth + spacing))
                .floor();
        var colunas = cabem.clamp(1, maxColumns);
        // Evita linha incompleta (ex.: 4 cartões em 3 colunas = 3 + 1).
        while (colunas > 1 &&
            colunas < children.length &&
            children.length % colunas != 0) {
          colunas--;
        }

        return Column(
          children: [
            for (var i = 0; i < children.length; i += colunas) ...[
              if (i > 0) SizedBox(height: spacing),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var c = 0; c < colunas; c++) ...[
                      if (c > 0) SizedBox(width: spacing),
                      Expanded(
                        child: i + c < children.length
                            ? children[i + c]
                            : const SizedBox(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Duas colunas lado a lado em telas largas; empilhadas nas estreitas.
class ResponsiveColumns extends StatelessWidget {
  final Widget start;
  final Widget end;
  final int startFlex;
  final int endFlex;
  final double spacing;

  const ResponsiveColumns({
    super.key,
    required this.start,
    required this.end,
    this.startFlex = 1,
    this.endFlex = 1,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.duasColunas) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              start,
              SizedBox(height: spacing),
              end,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: startFlex, child: start),
            SizedBox(width: spacing),
            Expanded(flex: endFlex, child: end),
          ],
        );
      },
    );
  }
}
