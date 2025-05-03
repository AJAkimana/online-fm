import 'package:flutter/material.dart';
import 'package:online_fm/models/radio_station.dart';
import 'package:online_fm/screens/widgets/radio_display.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[800]!, Colors.black],
          )
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Text(
                'FM Radio',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: isPoweredOn? Colors.blue : Colors.grey,
                ),
                onPressed: togglePower,
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Radio controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: isPoweredOn ? () => tuneRadio(currentFrequency - 0.1) : null,
                        ),
                        Text(
                          currentFrequency.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            color: isPoweredOn ? Colors.black : Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'MHz',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: isPoweredOn ? Colors.black : Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isPoweredOn ? Colors.grey : Colors.grey[400],
                              ),
                              onPressed: isPoweredOn ? () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              } : null,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: isPoweredOn ? () => tuneRadio(currentFrequency + 0.1) : null,
                        ),
                      ],
                    ),

                    // Radio tuner wheel
                    const SizedBox(height: 20),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Tuner scale
                          CustomPaint(
                            size: const Size(200, 200),
                            painter: TunerScalePainter(
                              currentFrequency: currentFrequency,
                              isActive: isPoweredOn,
                            ),
                          ),
                          // Center knob
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFE0E0E0),
                                  Color(0xFFA0A0A0),
                                ],
                              ),
                            ),
                            child: GestureDetector(
                              onPanUpdate: isPoweredOn ? (details) {
                                setState(() {
                                  // Update frequency based on horizontal drag
                                  final delta = details.delta.dx * 0.02;
                                  currentFrequency = (currentFrequency + delta).clamp(87.5, 108.0);
                                  isFavorite = stations.any(
                                        (station) => station.frequency == currentFrequency.toStringAsFixed(1) && station.isFavorite,
                                  );
                                });
                              } : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Volume slider
                    Row(
                      children: [
                        const Icon(Icons.volume_up, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
                          'VOL',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: 0.7,
                            onChanged: isPoweredOn ? (value) {} : null,
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Preset buttons
                    SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...presetFrequencies.map((freq) => PresetButton(
                            frequency: freq,
                            isActive: isPoweredOn,
                            onPressed: isPoweredOn ? () => tuneRadio(freq) : null,
                          )),
                          ...List.generate(4, (index) => const PresetButton(
                            frequency: null,
                            isActive: false,
                            onPressed: null,
                          )),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
