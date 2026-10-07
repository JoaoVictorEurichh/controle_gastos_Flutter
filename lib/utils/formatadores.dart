const nomesMesesAbreviados = [
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez',
];

String _milhares(String inteiro) {
  final buffer = StringBuffer();
  for (var i = 0; i < inteiro.length; i++) {
    if (i > 0 && (inteiro.length - i) % 3 == 0) buffer.write('.');
    buffer.write(inteiro[i]);
  }
  return buffer.toString();
}

/// Formata como moeda brasileira. Ex.: 1234.5 -> "R$ 1.234,50".
/// Com [centavos] falso: 1640 -> "R$ 1.640".
String formatarMoeda(double valor, {bool centavos = true}) {
  final negativo = valor < 0;
  final partes = valor.abs().toStringAsFixed(centavos ? 2 : 0).split('.');
  final texto = centavos
      ? '${_milhares(partes[0])},${partes[1]}'
      : _milhares(partes[0]);
  return '${negativo ? '- ' : ''}R\$ $texto';
}

/// Só o número no formato brasileiro, sem "R$". Ex.: 1234.5 -> "1.234,50".
String formatarNumero(double valor) =>
    formatarMoeda(valor).replaceFirst('R\$ ', '');

/// Formata uma data como "dd/mm/aaaa".
String formatarData(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  return '$dia/$mes/${data.year}';
}

/// Percentual com sinal, sem casas decimais. Ex.: 12.4 -> "+12%".
String formatarVariacao(double percentual) {
  final arredondado = percentual.round();
  return '${arredondado > 0 ? '+' : ''}$arredondado%';
}

/// Percentual simples a partir de uma fração. Ex.: 0.32 -> "32%".
String formatarPercentual(double fracao) => '${(fracao * 100).round()}%';

/// Rótulo curto para eixos de gráfico. Ex.: 2500 -> "2.5k".
String abreviarValor(double valor) {
  if (valor.abs() < 1000) return valor.round().toString();
  final milhares = valor / 1000;
  final texto = milhares == milhares.roundToDouble()
      ? milhares.round().toString()
      : milhares.toStringAsFixed(1);
  return '${texto}k';
}
