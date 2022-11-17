import 'package:analisesensibilidade/utils/colunas_tabela.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List resultadoSimplex = [
    [
      ['Base', 'x1', 'x2', 'x3', 's1', 's2', 's3', 'b'],
      ['x2', 0, 1, 0.83, 1.66, -0.16, 0, 66.66],
      ['x1', 1, 0, 0.16, -0.66, 0.16, 0, 33.33],
      ['s3', 0, 0, 4, -2, 0, 1, 100],
      ['z', 0, 0, 2.66, 3.33, 0.66, 0, 733.33],
    ]
  ];

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> _colunas = delimitaColunasSimplex(resultadoSimplex);
    Map<dynamic, dynamic> _colunaValorFinal = valorFinal(_colunas);
    Map<dynamic, dynamic> _colunaPrecoSombra =
        precoSombra(_colunas, _colunaValorFinal);
    Map<dynamic, dynamic> _colunasAumentarReduzir = aumentarReduzir(_colunas);
    atribuiValoresMinMax(_colunasAumentarReduzir);


    List<Widget> _geraColuna(List<dynamic> celulas) {
      List<Widget> _coluna = [];

      for (var i = 0; i < celulas.length; i++) {
        _coluna.add(
          Container(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(celulas[i].toString()),
            ),
            decoration: BoxDecoration(border: Border.all()),
          ),
        );
      }

      return _coluna;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: _geraColuna(_colunaValorFinal.keys.toList()),
                ),
                Column(
                  children: _geraColuna(_colunaValorFinal.values.toList()),
                ),
                Column(
                  children: _geraColuna(_colunaPrecoSombra.values.toList()),
                ),
                Column(
                  children: _geraColuna(valoresMax),
                ),
                Column(
                  children: _geraColuna(valoresMin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
