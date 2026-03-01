import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'services/weather_service.dart';
import 'services/mushroom_logic.dart';

void main() {
  runApp(const MycoApp());
}

class MycoApp extends StatelessWidget {
  const MycoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MycoPrognoza PL',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? index;
  String status = "Pobieranie danych...";
  String locationName = "Nieznana";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          status = "Brak zgody na lokalizację";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      locationName =
          "${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}";

      final weather = await WeatherService.getWeather(
          position.latitude, position.longitude);

      final result = MushroomLogic.calculateIndex(weather);

      setState(() {
        index = result;
        status = MushroomLogic.getStatus(result);
      });
    } catch (e) {
      setState(() {
        status = "Błąd pobierania danych";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🍄 MycoPrognoza PL"),
      ),
      body: Center(
        child: index == null
            ? Text(status)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Lokalizacja: $locationName"),
                  const SizedBox(height: 20),
                  Text(
                    "Indeks wysypu: ${index!.toStringAsFixed(0)}%",
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    status,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: fetchData,
                    child: const Text("Odśwież"),
                  )
                ],
              ),
      ),
    );
  }
}