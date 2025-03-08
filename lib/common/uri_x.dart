extension UriX on Uri {
  List<double?> get latLong =>
      path.split(';').first.split(',').map((s) => double.tryParse(s)).toList();
}
