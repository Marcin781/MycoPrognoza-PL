import 'weather_service.dart';

class MushroomLogic {
  static double calculateIndex(WeatherData data) {
    double score = 0;

    if (data.rainSum > 20) {
      score += 40;
    }

    if (data.avgHumidity > 70) {
      score += 25;
    }

    if (data.avgTemp >= 10 && data.avgTemp <= 22) {
      score += 25;
    }

    if (data.minTemp > 0) {
      score += 10;
    }

    return score;
  }

  static String getStatus(double index) {
    if (index > 70) {
      return "🔥 DUŻY WYSYP";
    } else if (index >= 40) {
      return "🟡 ŚREDNI WYSYP";
    } else {
      return "🔴 MAŁY WYSYP";
    }
  }
}