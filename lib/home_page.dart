import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  var temp, result;

  final TextEditingController t1 = new TextEditingController(text: "0");

  void doSolve() {
    setState(() {
      temp = double.parse(t1.text);
      result = ((temp - 32) / 1.8) + 237.15;
      result = result.toStringAsFixed(2);
    });
  }
// functions here

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Calculator"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: new ListView(
          children: [
            new Text(
              "Output: $result",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            new TextField(
              keyboardType: TextInputType.number,
              decoration:
                  new InputDecoration(hintText: "Enter temperature in deg F: "),
              controller: t1,
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new TextButton(
                    child: new Text("Clear"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent)),
                    onPressed: doSolve),
              ],
            )
          ],
        ),
      ),
    );
  }
}
