import 'dart:math';

List<String> variaveisFolga = ['s1', 's2', 's3'];
main() {
  // final List resultadoSimplex = [
  //   [
  //     ['Base', 'x1', 'x2', 'x3', 's1', 's2', 's3', 'b'],
  //     ['x2', 0, 1, 0.83, 1.66, -0.16, 0, 66.66],
  //     ['x1', 1, 0, 0.16, -0.66, 0.16, 0, 33.33],
  //     ['s3', 0, 0, 4, -2, 0, 1, 100],
  //     ['z', 0, 0, 2.66, 3.33, 0.66, 0, 733.33],
  //   ]
  // ];

  // Map<dynamic, dynamic> _colunas = delimitaColunasSimplex(resultadoSimplex);
  // Map<dynamic, dynamic> _colunaValorFinal = valorFinal(_colunas);
  // Map<dynamic, dynamic> _colunaPrecoSombra =
  //     _precoSombra(_colunas, _colunaValorFinal);
  // Map<dynamic, dynamic> _colunasAumentarReduzir =
  //     aumentarReduzir(_colunas);
}

Map<dynamic, dynamic> delimitaColunasSimplex(List tabelaSimplex) {
  int _qntLinhas = tabelaSimplex.first.length;
  int _qntColunas = tabelaSimplex.first[0].length;

  List _titulosColunas = [];
  Map<dynamic, dynamic> _colunas = {};

  for (var i = 0; i < _qntLinhas; i++) {
    for (var j = 0; j < _qntColunas; j++) {
      if (i == 0) {
        _titulosColunas.add(tabelaSimplex.first[i][j]);
        _colunas[_titulosColunas[j]] = [];
      } else {
        String _chave = _keyReferenteIndiceDoMap(_colunas, j);
        _colunas[_chave].add(
          tabelaSimplex.first[i][j],
        );
      }
    }
  }

  return _colunas;
}

_keyReferenteIndiceDoMap(Map<dynamic, dynamic> valor, int index) {
  return valor.keys.toList()[index];
}

Map<dynamic, dynamic> valorFinal(Map<dynamic, dynamic> tabela) {
  int _qntLinhas = _keyReferenteIndiceDoMap(tabela, 0).length;
  Map<dynamic, dynamic> _valorFinal = {};

  for (var i = 0; i < _qntLinhas; i++) {
    _valorFinal[tabela['Base'][i]] = tabela['b'][i];
  }

  _valorFinal.addAll(
    _insereVariaveisFolgaFaltantes(
      tabela.keys.toList(),
      _valorFinal.keys.toList(),
    ),
  );

  return _valorFinal;
}

Map<dynamic, dynamic> _insereVariaveisFolgaFaltantes(
    List<dynamic> titulosTabela, List<dynamic> titulosAtuais) {
  Map<dynamic, dynamic> _variavelFolgaFaltante = {};

  titulosTabela.forEach((titulo) {
    if (variaveisFolga.contains(titulo) && !titulosAtuais.contains(titulo)) {
      _variavelFolgaFaltante[titulo] = 0;
    }
  });

  return _variavelFolgaFaltante;
}

Map<dynamic, dynamic> _precoSombra(
    Map<dynamic, dynamic> colunas, Map<dynamic, dynamic> colunaVf) {
  List _colunaPosicaoBase = colunas['Base'];
  List _titulosColunasBase = colunaVf.keys.toList();
  Map<dynamic, dynamic> _colunaPrecoSombra = {};

  int _posicaoZ =
      _colunaPosicaoBase.indexWhere((elementoColuna) => elementoColuna == 'z');

  for (var i = 0; i < _titulosColunasBase.length; i++) {
    if (variaveisFolga.contains(_titulosColunasBase[i])) {
      _colunaPrecoSombra[_titulosColunasBase[i]] =
          colunas[_titulosColunasBase[i]][_posicaoZ];
    } else {
      _colunaPrecoSombra[_titulosColunasBase[i]] = '-';
    }
  }

  return _colunaPrecoSombra;
}

aumentarReduzir(
    Map<dynamic, dynamic> colunas) {
  Map<dynamic, dynamic> _valoresParaSeremOrdenados =
      _calculaValoresIdentificarMaxMin(colunas);
  Map<String, dynamic> _colunaAumentarReduzir = {};

  _colunaAumentarReduzir = _separaValoresMaxMin(_valoresParaSeremOrdenados);

  return _colunaAumentarReduzir;
}

Map<dynamic, dynamic> _separaValoresMaxMin(Map<dynamic, dynamic> valores) {
  int _qntColunas = valores.keys.length;
  Map<String, dynamic> _colunaMaxMin = {};

  for (var i = 0; i < _qntColunas; i++) {
    
    String _chave = _keyReferenteIndiceDoMap(valores, i);
    _colunaMaxMin[_chave] = {'max': 0, 'min': 0};
    valores[_chave].removeWhere((numero) => numero.isInfinite == true);

      Map<String, List<int>> _identificaValoresMaxMin = {'max': [], 'min': []};
    for (var j = 0; j < valores[_chave].length; j++) {
      if (valores[_chave][j] >= 0) {
        _identificaValoresMaxMin['max'].add(valores[_chave][j]);
      } else {
        _identificaValoresMaxMin['min'].add(valores[_chave][j]);
      }

      if (_identificaValoresMaxMin['min'].length > 0) {
        _colunaMaxMin[_chave]['min'] = _identificaValoresMaxMin['min'].reduce(min);
      }

      if (_identificaValoresMaxMin['max'].length > 0) {
        _colunaMaxMin[_chave]['max'] = _identificaValoresMaxMin['max'].reduce(min);
      }
    }

  }

  return _colunaMaxMin;
}

Map<dynamic, dynamic> _calculaValoresIdentificarMaxMin(
    Map<dynamic, dynamic> colunas) {
  int _qntLinhas = colunas["Base"].length;
  int _qntColunas = colunas.keys.length;
  Map<dynamic, dynamic> _valoresParaSeremOrdenados = {};

  for (var i = 1; i < _qntColunas - 1; i++) {
    String _chave = _keyReferenteIndiceDoMap(colunas, i);
    _valoresParaSeremOrdenados[_chave] = [];

    for (var j = 0; j < _qntLinhas - 1; j++) {
      var _operacaoEntreValoresColunas = colunas['b'][j] / colunas[_chave][j];

      if (!_operacaoEntreValoresColunas.isInfinite) {
        _operacaoEntreValoresColunas =
            int.parse((_operacaoEntreValoresColunas * (-1)).toStringAsFixed(0));
      }
      _valoresParaSeremOrdenados[_chave].add(
        _operacaoEntreValoresColunas,
      );
    }
  }

  return _valoresParaSeremOrdenados;
}
