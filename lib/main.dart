import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peter Card\'s Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _accumulator = '';
  String _operator = '';
  double _result = 0;

  void _onDigitPress(String digit) {
    setState(() {
      if (_display == '0') {
        _display = digit;
      } else {
        _display += digit;
      }
    });
  }

  void _onOperatorPress(String operator) {
    setState(() {
      _accumulator = _display;
      _operator = operator;
      _display = '0';
    });
  }

  void _onClearPress() {
    setState(() {
      _display = '0';
      _accumulator = '';
      _operator = '';
      _result = 0;
    });
  }

  void _onEqualsPress() {
    setState(() {
      double num1 = double.parse(_accumulator);
      double num2 = double.parse(_display);

      switch (_operator) {
        case '+':
          _result = num1 + num2;
          break;
        case '-':
          _result = num1 - num2;
          break;
        case '*':
          _result = num1 * num2;
          break;
        case '/':
          _result = num1 / num2;
          break;
      }
      _display = _result.toString();
    });
  }

  Widget _buildButton(String text, Function onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onPressed(text),
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                _display,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7', _onDigitPress),
                  _buildButton('8', _onDigitPress),
                  _buildButton('9', _onDigitPress),
                  _buildButton('/', _onOperatorPress),
                ],
              ),
              Row(
                children: [
                  _buildButton('4', _onDigitPress),
                  _buildButton('5', _onDigitPress),
                  _buildButton('6', _onDigitPress),
                  _buildButton('*', _onOperatorPress),
                ],
              ),
              Row(
                children: [
                  _buildButton('1', _onDigitPress),
                  _buildButton('2', _onDigitPress),
                  _buildButton('3', _onDigitPress),
                  _buildButton('-', _onOperatorPress),
                ],
              ),
              Row(
                children: [
                  _buildButton('0', _onDigitPress),
                  _buildButton('C', (_) => _onClearPress()),
                  _buildButton('=', (_) => _onEqualsPress()),
                  _buildButton('+', _onOperatorPress),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
