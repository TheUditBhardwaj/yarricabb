import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_models.dart';

class LocationService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  Timer? _debounceTimer;

  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty || query.length < 2) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search?q=$query&format=json&limit=5&addressdetails=1&countrycodes=in',
        ),
        headers: {
          'User-Agent': 'YatriCabs/1.0',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .where((item) =>
        item['type'] == 'city' ||
            item['type'] == 'administrative' ||
            item['class'] == 'place')
            .map((item) => City.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error searching cities: $e');
      return [];
    }
  }

  Future<List<City>> searchCitiesDebounced(
      String query,
      Duration delay,
      ) async {
    final completer = Completer<List<City>>();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () async {
      final cities = await searchCities(query);
      completer.complete(cities);
    });

    return completer.future;
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}