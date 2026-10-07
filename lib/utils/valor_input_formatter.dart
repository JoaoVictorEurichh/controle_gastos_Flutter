import 'package:flutter/services.dart';

import 'formatadores.dart';

/// Máscara de valor monetário: os dígitos preenchem a partir dos centavos.
/// Digitar "1", "2", "5", "0" mostra "0,01" → "0,12" → "1,25" → "12,50".
class ValorInputFormatter extends TextInputFormatter {
  static const _maxDigitos = 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitos = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.length > _maxDigitos) {
      digitos = digitos.substring(0, _maxDigitos);
    }
    if (digitos.isEmpty || int.parse(digitos) == 0) {
      return const TextEditingValue();
    }

    final texto = formatarNumero(int.parse(digitos) / 100);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }

  /// Converte o texto mascarado ("1.234,56") em número.
  static double lerValor(String texto) {
    final digitos = texto.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.isEmpty) return 0;
    return int.parse(digitos) / 100;
  }
}
