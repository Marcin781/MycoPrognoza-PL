import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double rainSum;
  final double avgTemp;
  final double minTemp;
  final double avgHumidity;

  WeatherData({
    required this.rainSum,
    required this.avgTemp,
    required this.minTemp,
    required this.avgHumidity,
  });
}

class WeatherService {
  static Future<WeatherData> getWeather(
      double latitude, double longitude) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,precipitation_sum&hourly=relative_humidity_2m&forecast_days=7";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final rainList =
          (data['daily']['precipitation_sum'] as List).cast<num>();
      final maxTempList =
          (data['daily']['temperature_2m_max'] as List).cast<num>();
      final minTempList =
          (data['daily']['temperature_2m_min'] as List).cast<num>();

      final humidityList =
          (data['hourly']['relative_humidity_2m'] as List).cast<num>();

      double rainSum =
          rainList.fold(0, (sum, item) => sum + item.toDouble());

      double avgTemp = maxTempList
              .fold(0, (sum, item) => sum + item.toDouble()) /
          maxTempList.length;

      double minTemp =
          minTempList.reduce((a, b) => a < b ? a : b).toDouble();

      double avgHumidity =
          humidityList.fold(0, (sum, item) => sum + item.toDouble()) /
              humidityList.length;

      return WeatherData(
        rainSum: rainSum,
        avgTemp: avgTemp,
        minTemp: minTemp,
        avgHumidity: avgHumidity,
      );
    } else {
      throw Exception("Błąd API");
    }
  }
}