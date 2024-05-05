class WeatherItem {
  const WeatherItem({
    required this.date,
    required this.temperatureC,
    required this.temperatureF,
    required this.summary,
  });

  final String date;
  final int temperatureC;
  final int temperatureF;
  final String summary;
}
