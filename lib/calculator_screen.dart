import 'package:flutter/material.dart';
import 'package:iceland_trip/rate.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late Currency iskCurrency;

  @override
  void initState() {
    iskCurrency = context.read<Rate>().iskCurrency;
    super.initState();
  }

  List<Widget> cardCurrency(Currency currency, Mode mode) {
    List<Widget> list = [];
    for (var amount
        in mode == Mode.toCurrency ? currency.amounts : iskCurrency.amounts) {
      Widget aux = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mode == Mode.toCurrency
              ? CurrencyItemList(currency: currency, amount: amount)
              : KronaItemList(currency: iskCurrency, amount: amount),
          const SizedBox(width: 10),
          mode == Mode.toCurrency
              ? KronaItemList(
                  currency: iskCurrency, amount: amount * currency.rate)
              : CurrencyItemList(
                  currency: currency, amount: amount * currency.invRate),
        ],
      );
      list.add(aux);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Currency currency = context.watch<Rate>().currentCurrency;
    Mode mode = context.watch<Rate>().currentMode;
    return Column(
      children: [
        const ChangeCard(),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [...cardCurrency(currency, mode)],
          ),
        ),
      ],
    );
  }
}

class KronaItemList extends StatelessWidget {
  const KronaItemList({
    Key? key,
    required this.currency,
    required this.amount,
  }) : super(key: key);

  final double amount;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 30,
      alignment: Alignment.centerRight,
      child: Text(
        '${amount.toStringAsFixed(0)} ${currency.shortName}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class CurrencyItemList extends StatelessWidget {
  const CurrencyItemList({
    Key? key,
    required this.currency,
    required this.amount,
  }) : super(key: key);

  final double amount;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 30,
      alignment: Alignment.centerRight,
      child: Text(
        '${amount.toStringAsFixed(2)} ${currency.shortName}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
          fontSize: 20,
        ),
      ),
    );
  }
}
