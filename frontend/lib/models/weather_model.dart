class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  /// Factory constructor to create from JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      humidity: (json['main']['humidity'] ?? 0).toInt(),
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}
