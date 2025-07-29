import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();

  WeatherModel? _weather;
  List<ForecastModel> _forecast = [];
  bool _loading = false;

  void _fetchWeather() async {
    setState(() => _loading = true);

    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    // Fetch current weather
    final currentData = await _weatherService.getCurrentWeather(city);
    if (currentData != null) {
      _weather = WeatherModel.fromJson(currentData);
    }

    // Fetch forecast
    final forecastData = await _weatherService.getForecast(city);
    if (forecastData != null) {
      _forecast = (forecastData['forecast'] as List)
          .map((item) => ForecastModel.fromJson(item))
          .toList();
    }

    setState(() => _loading = false);
  }

  String _getLottieAnimation(String icon) {
    if (icon.contains("01")) return "assets/sunny.json";
    if (icon.contains("02") || icon.contains("03")) return "assets/cloudy.json";
    if (icon.contains("09") || icon.contains("10")) return "assets/rain.json";
    if (icon.contains("13")) return "assets/snow.json";
    return "assets/cloudy.json";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5583EE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: "Enter City",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _fetchWeather,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Weather Info
                _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : _weather == null
                        ? const Text(
                            "Search for a city to see the weather",
                            style: TextStyle(color: Colors.white70),
                          )
                        : Column(
                            children: [
                              Lottie.asset(
                                _getLottieAnimation(_weather!.icon),
                                height: 150,
                              ),
                              Text(
                                "${_weather!.temperature.toStringAsFixed(1)}°C",
                                style: GoogleFonts.poppins(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _weather!.city,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                _weather!.description.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white54,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Extra Info
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _infoCard("💧", "${_weather!.humidity}%", "Humidity"),
                                  _infoCard("💨", "${_weather!.windSpeed} m/s", "Wind"),
                                ],
                              ),
                            ],
                          ),

                const SizedBox(height: 30),

                // Forecast
                if (_forecast.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _forecast.length,
                      itemBuilder: (context, index) {
                        final forecast = _forecast[index];
                        return _forecastCard(forecast);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _forecastCard(ForecastModel forecast) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(forecast.date),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Lottie.asset(_getLottieAnimation(forecast.icon), height: 50),
          Text(
            "${forecast.temperature.toStringAsFixed(1)}°C",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
