import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../theme/app_colors.dart';
import 'icon_badge.dart';

/// Abre a grade de categorias do [tipo] e devolve a escolhida.
Future<Categoria?> showCategorySelector(
  BuildContext context, {
  required TipoTransacao tipo,
  Categoria? selecionada,
}) {
  return showModalBottomSheet<Categoria>(
    context: context,
    isScrollControlled: true,
    builder: (_) => CategorySelector(tipo: tipo, selecionada: selecionada),
  );
}

class CategorySelector extends StatelessWidget {
  final TipoTransacao tipo;
  final Categoria? selecionada;

  const CategorySelector({super.key, required this.tipo, this.selecionada});

  @override
  Widget build(BuildContext context) {
    final categorias = Categoria.doTipo(tipo);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha a categoria',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                for (final c in categorias)
                  _CategoriaTile(
                    categoria: c,
                    selecionada: c == selecionada,
                    onTap: () => Navigator.pop(context, c),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriaTile extends StatelessWidget {
  final Categoria categoria;
  final bool selecionada;
  final VoidCallback onTap;

  const _CategoriaTile({
    required this.categoria,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borda = BorderRadius.circular(AppRadius.md);
    return Material(
      color: selecionada
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.surfaceHigh,
      shape: RoundedRectangleBorder(
        borderRadius: borda,
        side: BorderSide(
          color: selecionada ? AppColors.primary : AppColors.border,
          width: selecionada ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borda,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconBadge(
                icon: categoria.icone,
                color: categoria.cor,
                size: 42,
                circle: false,
              ),
              const SizedBox(height: 8),
              Text(
                categoria.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
