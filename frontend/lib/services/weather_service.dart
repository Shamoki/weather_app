import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl = "http://localhost:3000/weather";

  /// Fetch current weather
  Future<Map<String, dynamic>?> getCurrentWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/current?city=$city'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  /// Fetch 3-day forecast
  Future<Map<String, dynamic>?> getForecast(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forecast?city=$city'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
