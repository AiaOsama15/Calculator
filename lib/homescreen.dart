// import 'package:calculater/data.dart';

import 'package:calculater/data.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _HomeState();
}

class _HomeState extends State<CalculatorScreen> {
//  const Size screenSize = MediaQuery.of(context).size;
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9
  String total = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text(
            'Calculator',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
        body: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white38,
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2 ",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            //divider
            Container(
              height: 2,
              color: Colors.blueGrey,
            ),
            Wrap(
                children: Btn.buttonValues.map((value) {
              return SizedBox(
                  height: MediaQuery.of(context).size.width / 5,
                  width: value == Btn.n0
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 4,
                  child: buildButton(value));
            }).toList()),
          ],
        ),
      ),
    );
  }

//build each button
  Widget buildButton(value) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          clipBehavior: Clip.hardEdge,
          child: TextButton(
            style: TextButton.styleFrom(
              animationDuration: const Duration(seconds: 3),
              shadowColor: Colors.red,
              backgroundColor: buttonColor(value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19),
              ),
            ),
            onPressed: () => onBtnTap(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
          ),
        ),
      );
    });
  }

//colors
  Color buttonColor(value) {
    return [Btn.clr, Btn.del].contains(value)
        ? Colors.blueGrey
        : [
            Btn.n0,
            Btn.n1,
            Btn.n2,
            Btn.n3,
            Btn.n4,
            Btn.n5,
            Btn.n6,
            Btn.n7,
            Btn.n8,
            Btn.n9
          ].contains(value)
            ? Colors.greenAccent
            : Colors.orangeAccent;
  }

  //onpress button
  // ########
  void onBtnTap(String value) {
    rightEqation(value);
    //del
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      percentage();
      return;
    }
    //cal
    if (value == Btn.calculate) {
      calculate();
      return;
    }
  }

  //########
  void calculate() {
    if (number1.isEmpty) {
      return;
    }
    if (number2.isEmpty) return;
    if (operand.isEmpty) return;

    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      final double parseNumber1 = double.parse(number1);
      final double parseNumber2 = double.parse(number2);
      // double result = parseNumber1 + parseNumber2;
      var result = 0.0;
      switch (operand) {
        case Btn.add:
          result = parseNumber1 + parseNumber2;
          break;
        case Btn.subtract:
          result = parseNumber1 - parseNumber2;
          break;
        case Btn.multiply:
          result = parseNumber1 * parseNumber2;
          break;
        case Btn.divide:
          result = parseNumber1 / parseNumber2;
          break;
      }
      setState(() {
        number1 = result.toStringAsPrecision(3);

        if (number1.endsWith(".0")) {
          number1 = number1.substring(0, number1.length - 2);
        }

        operand = "";
        number2 = "";
      });
    }
  }

  //########
  void percentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
      //percentage
    }
    if (operand.isNotEmpty) {
      return;
    }
    if (number2.isEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = '';
      number2 = '';
    });
  }

  //########
  void clearAll() {
    setState(() {
      number1 = '';
      number2 = '';
      operand = '';
    });
  }

  //########
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  //###############
  //how we know num1? 1225  * 22122 --- condition of right equation
  void rightEqation(value) {
    //operand check
    if (value != Btn.dot && int.tryParse(value) == null) {
      //=operand
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // equation is true  //1225  * 22122
        calculate();
      }
      operand = value;
    } //check number 1
    else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    }
    //check number 2
    else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {
      // number1 += value;
      // operand += value;
      // number2 += value;
    });
  }
}
