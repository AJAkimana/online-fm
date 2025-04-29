import 'package:flutter/material.dart';
import 'package:online_fm/models/radio_station.dart';

class FMRadioScreen extends StatefulWidget{
  const FMRadioScreen({Key? key}):super(key: key);

  @override
  State<FMRadioScreen> createState() => _FMRadioScreenState();
}

class _FMRadioScreenState extends State<FMRadioScreen>{
  double currentFrequency = 94.8;
  bool isPoweredOn = true;
  bool isFavorite = false;
  List<RadioStation> stations = [];
  List<double> presetFrequencies = [94.0, 87.5];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  void tuneRadio(double frequency) {
    setState(() {
      currentFrequency = frequency;
      isFavorite = stations.any(
            (station) => station.frequency == frequency.toStringAsFixed(1) && station.isFavorite,
      );
    });
  }

  void togglePower() {
    setState(() {
      isPoweredOn = !isPoweredOn;
    });
  }
}
