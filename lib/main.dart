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
  String _expression = '';
  double _result = 0;
  bool _justCalculated = false;

  List<String> _tokens = [];

  void _onDigitPress(String digit) {
    setState(() {
      if (_justCalculated) {
        _display = digit;
        _expression = digit;
        _tokens = [digit];
        _justCalculated = false;
      } else {
        if (_display == '0') {
          _display = digit;
        } else {
          _display += digit;
        }
        _expression += digit;
        _tokens.add(digit);
      }
    });
  }

  void _onOperatorPress(String operator) {
    setState(() {
      if (_justCalculated) {
        _tokens = [_result.toString()];
        _justCalculated = false;
      }

      if (_tokens.isNotEmpty) {
        _tokens.add(operator);
        _expression += ' $operator ';
        _display = '0';
      }
    });
  }

  void _onClearPress() {
    setState(() {
      _display = '0';
      _expression = '';
      _tokens = [];
      _result = 0;
      _justCalculated = false;
    });
  }

  double _computeResult() {
    // Handle operation priority (*/ first)
    List<String> tempTokens = List.from(_tokens);
    for (int i = 0; i < tempTokens.length; i++) {
      if (tempTokens[i] == '*' || tempTokens[i] == '/') {
        double left = double.parse(tempTokens[i - 1]);
        double right = double.parse(tempTokens[i + 1]);
        double intermediateResult;
        if (tempTokens[i] == '*') {
          intermediateResult = left * right;
        } else {
          intermediateResult = left / right;
        }
        // Replace the [left, op, right] with the result
        tempTokens.replaceRange(i - 1, i + 2, [intermediateResult.toString()]);
        i--;  // Step back to recheck the current position
      }
    }

    // Now process the remaining + and -
    double result = double.parse(tempTokens[0]);
    for (int i = 1; i < tempTokens.length; i += 2) {
      String operator = tempTokens[i];
      double right = double.parse(tempTokens[i + 1]);
      if (operator == '+') {
        result += right;
      } else if (operator == '-') {
        result -= right;
      }
    }

    return result;
  }

  void _onEqualsPress() {
    setState(() {
      if (_tokens.isEmpty || _tokens.length < 3) return;  // Nothing to calculate

      _result = _computeResult();
      _display = _result.toString();
      _expression = '';
      _tokens = [];
      _justCalculated = true;  // Flag to track if we just hit equals
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,  // Show expression
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  Text(
                    _display,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
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
