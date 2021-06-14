import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  static const Tc = 647.096, pc = 22064000, alpha_0 = 1000, rho_c = 322;
  double dAlpha = -1135.905627715;
  var result,
      pres,
      theta,
      tau,
      tempVar,
      ans,
      lntau,
      lnTau0,
      lnTau1,
      lnTau2,
      ans1,
      temp;

  List<double> a = [
    -7.85951783,
    1.84408259,
    -11.7866497,
    22.6807411,
    -15.9618719,
    1.80122502
  ];

  List<double> b = [
    1.99274064,
    1.09965342,
    -0.510839303,
    -1.75493479,
    -45.5170352,
    -674694.45
  ];

  List<double> d = [
    -0.0000000565134998,
    2690.66631,
    127.287297,
    -135.003439,
    0.981825814
  ];

  final TextEditingController t1 = new TextEditingController(text: "0");

  double satPres(double temp) {
    theta = temp / Tc;
    tau = 1 - theta;
    tempVar = (Tc / temp) *
        (a[0] * tau +
            a[1] * pow(tau, 1.5) +
            a[2] * pow(tau, 3) +
            a[3] * pow(tau, 3.5) +
            a[4] * pow(tau, 4) +
            a[5] * pow(tau, 7.5));
    ans = pc * exp(tempVar);
    return ans;
  }

  double rhoL(double temp) {
    theta = temp / Tc;
    tau = 1 - theta;
    lntau = log(tau);
    tempVar = 1 +
        b[0] * exp(lntau / 3.0) +
        b[1] * exp(2.0 * lntau / 3.0) +
        b[2] * exp(5.0 * lntau / 3.0) +
        b[3] * exp(16.0 * lntau / 3.0) +
        b[4] * exp(43.0 * lntau / 3.0) +
        b[5] * exp(110.0 * lntau / 3.0);
    ans = rho_c * (tempVar * 1.0);
    return ans;
  }

  double alpha(double temp) {
    theta = temp / Tc;
    tempVar = dAlpha +
        d[0] * pow(theta, -19) +
        d[1] * pow(theta, 1) +
        d[2] * pow(theta, 4.5) +
        d[3] * pow(theta, 5) +
        d[4] * pow(theta, 54.5);
    ans = alpha_0 * tempVar;
    return ans;
  }

  double dpdT(double pres, double temp) {
    theta = temp / Tc;
    tau = 1 - theta;
    lnTau0 = 6.5 * log(tau);
    lnTau1 = 2.5 * log(tau);
    lnTau2 = 0.5 * log(tau);
    tempVar = (7.5 * a[5] * exp(lnTau0)) +
        (4 * a[4] * pow(tau, 3)) +
        (3.5 * a[3] * exp(lnTau1)) +
        (3 * a[2] * pow(tau, 2)) +
        (1.5 * a[1] * exp(lnTau2)) +
        a[0] +
        (log(pres / pc));
    ans = -1 * (pres / temp) * tempVar;
    return ans;
  }

  void tempInputEnthalpy() {
    setState(() {
      temp = double.parse(t1.text);
      temp = ((temp - 32) / 1.8) + 273.15;
      pres = satPres(temp);

      result = alpha(temp) + ((temp / rhoL(temp)) * dpdT(pres, temp));
      result = result / (1055.056 * 2.2046226);
      result = result.toStringAsFixed(6);
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
              "Enthalpy(liquid) is: $result" + " Btu/lb",
              style: new TextStyle(
                  fontSize: 16.0,
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
                    child: new Text("Solve"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent)),
                    onPressed: tempInputEnthalpy),
              ],
            )
          ],
        ),
      ),
    );
  }
}
