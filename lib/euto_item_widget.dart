import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iceland_trip/rate.dart';
import 'package:iceland_trip/tools.dart';
import 'package:provider/provider.dart';

import 'inputs_formatters/euro_regex_input_formatter.dart';

class EuroItem extends StatefulWidget {
  const EuroItem({Key? key}) : super(key: key);

  @override
  State<EuroItem> createState() => _EuroItemState();
}

class _EuroItemState extends State<EuroItem> {
  final TextEditingController _textFieldControllerEuro =
      TextEditingController();
  double result = 0.0;
  String valueText = '0';

  List<Widget> cardEuro(double rate) {
    List<double> amounts = [
      0.5,
      1,
      3,
      5,
      8,
      10,
      15,
      20,
      30,
      50,
      75,
      100,
      150,
      300,
      500,
      750,
      1000,
      3000,
      5000,
      10000
    ];
    List<Widget> list = [];
    for (var amount in amounts) {
      Widget aux = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 30,
            alignment: Alignment.centerRight,
            child: Text(
              '${amount.toStringAsFixed(2)} EUR',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
          ),
          const SizedBox(width: 10),
          Container(
              width: 120,
              height: 30,
              alignment: Alignment.centerRight,
              child: Text('${Tools.changeCurrency(amount, rate, 0)} ISK'))
        ],
      );
      list.add(aux);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    double rate = context.watch<Rate>().rateEuroKrona;

    return Column(
      children: [
        SizedBox(
          width: 320,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 16),
                  const Image(
                      image: AssetImage('assets/images/eur-flag.png'),
                      height: 24,
                      width: 38),
                  SizedBox(
                    width: 210,
                    child: TextField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      inputFormatters: [EuroRegExInputFormatter()],
                      onChanged: (value) {
                        valueText = Tools.isNumeric(value) ? value : '0';

                        setState(() {
                          result = double.parse(valueText) * rate;
                        });
                      },
                      controller: _textFieldControllerEuro,
                      decoration: InputDecoration(
                        hintText: "0",
                        prefixIcon: IconButton(
                          onPressed: () {
                            _textFieldControllerEuro.clear();
                            valueText = '0';
                            setState(() {
                              result = 0;
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ),
                  const Text('EUR',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  const Image(
                      image: AssetImage('assets/images/iceland-flag.png'),
                      height: 24,
                      width: 38),
                  SizedBox(
                    width: 210,
                    child: Text(
                      result.toStringAsFixed(0),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ),
                  Text('ISK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[900])),
                  const SizedBox(height: 16),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [...cardEuro(rate)],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textFieldControllerEuro.dispose();
    super.dispose();
  }
}
