import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bilimsel Hesap Makinesi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          // Otomatik olarak parantezi kapat
          if (_expression.contains('(') && !_expression.contains(')')) {
            _expression += ')';
          }
          // Dereceleri radyana çevir
          String expWithRadians = _convertDegreesToRadians(_expression);
          Parser p = Parser();
          Expression exp = p.parse(expWithRadians);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = eval.toStringAsFixed(6); // Sonucu 6 basamağa yuvarla
        } catch (e) {
          _result = 'Hata';
        }
      } else if (value == 'sin' ||
          value == 'cos' ||
          value == 'tan' ||
          value == 'sqrt' ||
          value == 'ln') {
        _expression += value + '(';
      } else if (value == '^' || value == '!') {
        _expression += value;
      } else {
        _expression += value;
      }
    });
  }

  String _convertDegreesToRadians(String expression) {
    // Trigonometrik fonksiyonların derecelerini radyana çevir
    String pattern = r'(sin|cos|tan)\(([^()]+)\)';
    RegExp regExp = RegExp(pattern);
    String newExpression = expression.replaceAllMapped(regExp, (match) {
      String func = match.group(1)!;
      String angle = match.group(2)!;
      double angleInDegrees = double.parse(angle);
      double angleInRadians = angleInDegrees * (3.141592653589793 / 180);
      return '$func($angleInRadians)';
    });
    return newExpression;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bilimsel Hesap Makinesi')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _expression,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _result,
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          Column(
            children: [
              _buildButtonRow(['7', '8', '9', '/']),
              _buildButtonRow(['4', '5', '6', '*']),
              _buildButtonRow(['1', '2', '3', '-']),
              _buildButtonRow(['0', '.', '=', '+']),
              _buildButtonRow(['sin', 'cos', 'tan', 'C']),
              _buildButtonRow(['sqrt', '^', '!', 'ln']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return _buildButton(button);
      }).toList(),
    );
  }

  Widget _buildButton(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(value),
          child: Text(
            value,
            style: TextStyle(fontSize: 20.0),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(),
          ),
        ),
      ),
    );
  }
}
