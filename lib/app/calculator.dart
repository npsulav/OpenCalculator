import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpressionNotifier extends ChangeNotifier {
  var value = "";

  set(expression) {
    this.value = expression;
    notifyListeners();
  }
}

class ResultNotifier extends ChangeNotifier {
  var res = "0";

  set(res) {
    this.res = res;
    notifyListeners();
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ExpressionNotifier expression = ExpressionNotifier();
    ResultNotifier resN = ResultNotifier();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExpressionNotifier>(create: (_) => expression),
        ChangeNotifierProvider<ResultNotifier>(create: (_) => resN)
      ],
      child: Scaffold(
          backgroundColor: Color(0xff22252D), //0xff292D36
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 35, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Consumer<ExpressionNotifier>(
                          builder: (context, value, child) => Expanded(
                            child: Text(
                              value.value.toString(),
                              textAlign: TextAlign.end,
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Consumer<ResultNotifier>(
                          builder: (context, value, child) => Expanded(
                            child: Text(
                              "= " + value.res.toString(),
                              textAlign: TextAlign.end,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff292D36),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 15, top: 50),
                  child: Table(
                    children: [
                      TableRow(children: [
                        _btnCard(
                            onPressed: () {
                              expression.set("");
                            },
                            colorValue: Colors.green,
                            text: "C"),
                        _btnCard(
                            onPressed: () {
                              var ex = expression.value.split("");
                              ex.removeLast();

                              expression.set(ex.join());
                            },
                            colorValue: Colors.green,
                            text: "<"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "%");
                            },
                            colorValue: Colors.green,
                            text: "%"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "/");
                            },
                            colorValue: Colors.red,
                            text: "÷"),
                      ]),
                      TableRow(children: [
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "7");
                            },
                            text: "7"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "8");
                            },
                            text: "8"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "9");
                            },
                            text: "9"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "*");
                            },
                            colorValue: Colors.red,
                            text: "*")
                      ]),
                      TableRow(children: [
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "4");
                            },
                            text: "4"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "5");
                            },
                            text: "5"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "6");
                            },
                            text: "6"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "-");
                            },
                            colorValue: Colors.red,
                            text: "-")
                      ]),
                      TableRow(children: [
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "1");
                            },
                            text: "1"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "2");
                            },
                            text: "2"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "3");
                            },
                            text: "3"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "+");
                            },
                            colorValue: Colors.red,
                            text: "+"),
                      ]),
                      TableRow(children: [
                        _btnCard(
                            onPressed: () {
                              showAboutDialog(
                                  context: context,
                                  applicationIcon: FlutterLogo(),
                                  applicationName: "Open Calculator",
                                  applicationVersion: "0.0.1",

                                  children: [
                                    Text("Open Calculator is a open source Calculator that uses Flutter UI, expressions and provider package. The source code of this application can be found here:"),

                                  ]);
                            },
                            text: "i"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + "0");
                            },
                            text: "0"),
                        _btnCard(
                            onPressed: () {
                              expression.set(expression.value + ".");
                            },
                            text: "."),
                        _btnCard(
                            onPressed: () {
                              Expression ex2 =
                                  Expression.parse(expression.value);
                              // Evaluate expression
                              final evaluator = const ExpressionEvaluator();
                              var r = evaluator.eval(ex2, {});
                              print(r);
                              resN.set(r.toString());
                            },
                            colorValue: Colors.red,
                            text: "="),
                      ]),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }


  void _launchURL() async =>
      await canLaunch("") ? await launch("https://github.com/npsulav/OpenCalculator") : throw 'Could not launch';


  Widget _btnCard({onPressed, colorValue = Colors.white, text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
      child: MaterialButton(
        color: Color(0xff272B33),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text.toString(),
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: colorValue),
          ),
        ),
      ),
    );
  }
}
