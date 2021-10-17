import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iceland_trip/euto_item_widget.dart';
import 'package:iceland_trip/krona_item_widget.dart';
import 'package:iceland_trip/rate.dart';
import 'package:iceland_trip/inputs_formatters/rate_regex_input_formatter.dart';
import 'package:iceland_trip/tools.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Rate()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Iceland Trip';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const IconData icelandKronaCurrency =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);

  int _selectedIndex = 0;
  late String valueText;

  static const List<Widget> _widgetOptions = <Widget>[
    EuroItem(),
    KronaItem(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    valueText = context.read<Rate>().rateEuroKrona.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iceland Trip'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _textFieldController.text =
                      context.read<Rate>().rateEuroKrona.toString();
                  _displayTextInputDialog(context);
                },
                child: const Icon(Icons.settings, size: 26.0),
              ))
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.euro),
            label: 'Euro',
          ),
          BottomNavigationBarItem(
            icon: Icon(icelandKronaCurrency),
            label: 'Krona',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }

  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change rate'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Current rate:'),
                Text('1 EUR = $valueText ISK'),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) {
                    valueText = value;
                  },
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [RateRegExInputFormatter()],
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintText: "Insert rate",
                    prefix: const Text("1 EUR = "),
                    suffix: const Text(" ISK"),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textFieldController.clear();
                        valueText = '0';
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  valueText = Tools.isNumeric(valueText) ? valueText : '0';
                  context.read<Rate>().changeRate(double.parse(valueText));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
