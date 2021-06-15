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
      result1,
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

  List<double> c = [
    -2.03150240,
    -2.68302940,
    -5.38626492,
    -17.2991605,
    -44.7586581,
    -63.9201063
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

  double rhoV(double temp) {
    theta = temp / Tc;
    tau = 1 - theta;
    lntau = log(tau);
    tempVar = c[0] * exp(lntau / 3.0) +
        c[1] * exp(2.0 * lntau / 3.0) +
        c[2] * exp(4.0 * lntau / 3.0) +
        c[3] * exp(3.0 * lntau) +
        c[4] * exp(37.0 * lntau / 6.0) +
        c[5] * exp(71.0 * lntau / 6.0);
    ans = rho_c * exp(tempVar * 1.0);
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

      //liquid
      result = alpha(temp) + ((temp / rhoL(temp)) * dpdT(pres, temp));
      result = result / (1055.056 * 2.2046226);
      result = result.toStringAsFixed(6);
      //vapor
      result1 = alpha(temp) + ((temp / rhoV(temp)) * dpdT(pres, temp));
      result1 = result1 / (1055.056 * 2.2046226);
      result1 = result1.toStringAsFixed(6);
    });
  }

  void doClear() {
    setState(() {
      result = 0;
      result1 = 0;

      t1.text = "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Steam Enthalpy: Temperature"),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: [
            Text(
              "Enthalpy(liquid) is: $result" + " Btu/lb",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            Text(
              "Enthalpy(vapor) is: $result1" + " Btu/lb",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(hintText: "Enter temperature in deg F: "),
              controller: t1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    child: Text("Solve"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent)),
                    onPressed: tempInputEnthalpy),
                TextButton(
                    child: Text("Clear"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent)),
                    onPressed: doClear),
              ],
            )
          ],
        ),
      ),
    );
  }
}
