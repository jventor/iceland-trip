import 'package:flutter/material.dart';
import 'package:iceland_trip/rate.dart';
import 'package:iceland_trip/tools.dart';
import 'package:provider/provider.dart';

const labelFontSize = 30.0;

class ChangeCard extends StatefulWidget {
  const ChangeCard({Key? key}) : super(key: key);

  @override
  _ChangeCardState createState() => _ChangeCardState();
}

class _ChangeCardState extends State<ChangeCard> {
  final TextEditingController _textFieldController = TextEditingController();
  double result = 0.0;
  String valueText = '0';
  late Mode mode;
  late Currency iskCurrency;

  @override
  void initState() {
    iskCurrency = context.read<Rate>().iskCurrency;
    mode = context.read<Rate>().currentMode;
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void clear() {
    _textFieldController.clear();
    valueText = '0';
    setState(() {
      result = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Currency currency = context.watch<Rate>().currentCurrency;
    final mode = context.watch<Rate>().currentMode;
    if (mode != this.mode) {
      this.mode = mode;
      clear();
    }

    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 16),
              Image(
                  image: AssetImage(mode == Mode.toCurrency
                      ? currency.flag
                      : iskCurrency.flag),
                  height: 30,
                  width: 40),
              Expanded(
                //width: 210,
                child: TextField(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: labelFontSize,
                    color: Colors.blue[900],
                  ),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    mode == Mode.toCurrency
                        ? currency.formatter
                        : iskCurrency.formatter
                  ],
                  onChanged: (value) {
                    valueText = Tools.isNumeric(value) ? value : '0';

                    setState(() {
                      result = mode == Mode.toCurrency
                          ? double.parse(valueText) * currency.rate
                          : double.parse(valueText) * currency.invRate;
                    });
                  },
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintText: "0",
                    prefixIcon: IconButton(
                      onPressed: () => clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                    mode == Mode.toCurrency
                        ? currency.shortName
                        : iskCurrency.shortName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: labelFontSize,
                      color: Colors.blue.shade900,
                    )),
              ),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Image(
                  image: AssetImage(
                    mode == Mode.toKrona ? currency.flag : iskCurrency.flag,
                  ),
                  height: 30,
                  width: 40),
              Expanded(
                // width: 210,
                child: Text(
                  mode == Mode.toCurrency
                      ? result.toStringAsFixed(0)
                      : result.toStringAsFixed(2),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                    mode == Mode.toCurrency
                        ? iskCurrency.shortName
                        : currency.shortName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: labelFontSize,
                      color: Colors.blue[900],
                    )),
              ),
              const SizedBox(height: 16),
            ],
          )
        ],
      ),
    );
  }
}
