import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Text('Maps')],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
