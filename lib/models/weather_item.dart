class WeatherItem {
  const WeatherItem({
    required this.id,
    required this.date,
    required this.temperatureC,
    required this.temperatureF,
    required this.summary,
  });

  final int id;
  final String date;
  final int temperatureC;
  final int temperatureF;
  final String summary;
}
