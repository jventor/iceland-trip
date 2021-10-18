import 'package:flutter/material.dart';
import 'package:iceland_trip/inputs_formatters/krona_regex_input_formatter.dart';
import 'package:iceland_trip/rate.dart';
import 'package:iceland_trip/tools.dart';
import 'package:provider/provider.dart';

class KronaItem extends StatefulWidget {
  const KronaItem({
    Key? key,
  }) : super(key: key);

  @override
  State<KronaItem> createState() => _KronaItemState();
}

class _KronaItemState extends State<KronaItem> {
  final TextEditingController _textFieldControllerKrona =
      TextEditingController();
  double result = 0.0;
  String valueText = '0';

  List<Widget> cardKrona(double rate) {
    List<double> amounts = [
      5,
      10,
      25,
      50,
      75,
      100,
      250,
      500,
      750,
      1000,
      2500,
      5000,
      7500,
      10000,
      25000,
      50000,
      75000,
      100000,
      250000,
      500000,
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
              '${amount.toStringAsFixed(0)} ISK',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
          ),
          const SizedBox(width: 10),
          Container(
              width: 120,
              height: 30,
              alignment: Alignment.centerRight,
              child: Text('${Tools.changeCurrency(amount, rate, 2)} EUR'))
        ],
      );
      list.add(aux);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    double rate = context.watch<Rate>().rateKronaEuro;

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
                      image: AssetImage('assets/images/iceland-flag.png'),
                      height: 24,
                      width: 38),
                  SizedBox(
                    width: 210,
                    child: TextField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      inputFormatters: [KronaRegExInputFormatter()],
                      onChanged: (value) {
                        valueText = Tools.isNumeric(value) ? value : '0';

                        setState(() {
                          result = double.parse(valueText) * rate;
                        });
                      },
                      controller: _textFieldControllerKrona,
                      decoration: InputDecoration(
                        hintText: "0",
                        prefixIcon: IconButton(
                          onPressed: () {
                            _textFieldControllerKrona.clear();
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
                  const Text('ISK',
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
                      image: AssetImage('assets/images/eur-flag.png'),
                      height: 24,
                      width: 38),
                  SizedBox(
                    width: 210,
                    child: Text(
                      result.toStringAsFixed(2),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ),
                  Text('EUR',
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
            children: [...cardKrona(rate)],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textFieldControllerKrona.dispose();
    super.dispose();
  }
}
