class ForecastModel {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  ForecastModel({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}
