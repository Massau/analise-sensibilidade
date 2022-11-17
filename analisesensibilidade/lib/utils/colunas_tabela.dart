import 'dart:math';

List<String> variaveisFolga = ['s1', 's2', 's3'];
List valoresMin = [];
List valoresMax = [];

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

Map<dynamic, dynamic> precoSombra(
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

aumentarReduzir(Map<dynamic, dynamic> colunas) {
  Map<dynamic, dynamic> _valoresParaSeremOrdenados =
      _calculaValoresIdentificarMaxMin(colunas);
  Map<String, dynamic> _colunaAumentarReduzir = {};

  _colunaAumentarReduzir = _separaValoresMaxMin(_valoresParaSeremOrdenados);

  return _colunaAumentarReduzir;
}

atribuiValoresMinMax(Map<String, dynamic> colunaAumentarReduzir) {
  colunaAumentarReduzir.forEach((key, value) {
    valoresMin.add(value['min']);
    valoresMax.add(value['max']);
  });
}

Map<dynamic, dynamic> _separaValoresMaxMin(Map<dynamic, dynamic> valores) {
  Map<String, dynamic> _colunaMaxMin = {};

  valores.forEach((key, value) {
    _colunaMaxMin[key] = {'max': '-', 'min': '-'};

    if (key.contains('s')) {
      List<int> _valoresFormatados = value.cast<int>();
      valores[key].removeWhere((numero) => numero.isInfinite == true);

      List<int> _valoresNegativos = _valoresFormatados
          .where((valorAtual) => valorAtual.isNegative)
          .toList();
      _colunaMaxMin[key]['min'] =
          _valoresNegativos.reduce(min).toString();

      _valoresFormatados
          .removeWhere((valorAtual) => _valoresNegativos.contains(valorAtual));

      if (_valoresFormatados.length > 0) {
        _colunaMaxMin[key]['max'] =
            _valoresFormatados.reduce(max).toString();
      } else {
        _colunaMaxMin[key]['max'] = '∞';
      }
    }
  });

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
      var _operacaoEntreValoresColunas;

      if (_chave.contains('s')) {
        _operacaoEntreValoresColunas = colunas['b'][j] / colunas[_chave][j];

        if (!_operacaoEntreValoresColunas.isInfinite) {
          if (_chave.contains('s2')) {
            print('object');
          }
          _operacaoEntreValoresColunas = int.parse(
              (_operacaoEntreValoresColunas * (-1)).toStringAsFixed(0));
        }
      } else {
        _operacaoEntreValoresColunas = '-';
      }

      _valoresParaSeremOrdenados[_chave].add(
        _operacaoEntreValoresColunas,
      );
    }
  }

  return _valoresParaSeremOrdenados;
}
