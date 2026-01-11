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
      print('🔍 Searching for: $query');

      final uri = Uri.parse(
        '$_baseUrl/search?q=$query&format=json&limit=10&addressdetails=1&countrycodes=in',
      );

      print('📡 API URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'YatriCabs/1.0',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏰ Request timeout');
          throw TimeoutException('Request timeout');
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Found ${data.length} results');

        if (data.isEmpty) {
          print('No results found for: $query');
          return [];
        }

        // Filter for cities and relevant places
        final cities = data
            .where((item) {
          final type = item['type']?.toString().toLowerCase() ?? '';
          final placeClass = item['class']?.toString().toLowerCase() ?? '';

          return type == 'city' ||
              type == 'town' ||
              type == 'village' ||
              type == 'administrative' ||
              placeClass == 'place' ||
              placeClass == 'boundary';
        })
            .map((item) => City.fromJson(item))
            .toList();

        print('Filtered to ${cities.length} cities');
        return cities;
      } else {
        print('Error status code: ${response.statusCode}');
        print(' Response body: ${response.body}');
        return [];
      }
    } on TimeoutException catch (e) {
      print(' Timeout error: $e');
      return [];
    } on FormatException catch (e) {
      print('JSON parse error: $e');
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
      if (!completer.isCompleted) {
        completer.complete(cities);
      }
    });

    return completer.future;
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}

// import 'dart:async';



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/booking_models.dart';
//
// class LocationService {
//   static const String _baseUrl = 'https://nominatim.openstreetmap.org';
//   Timer? _debounceTimer;
//
//   Future<List<City>> searchCities(String query) async {
//     if (query.isEmpty || query.length < 2) {
//       return [];
//     }
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//           '$_baseUrl/search?q=$query&format=json&limit=5&addressdetails=1&countrycodes=in',
//         ),
//         headers: {
//           'User-Agent': 'YatriCabs/1.0',
//         },
//       ).timeout(const Duration(seconds: 5));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data
//             .where((item) =>
//         item['type'] == 'city' ||
//             item['type'] == 'administrative' ||
//             item['class'] == 'place')
//             .map((item) => City.fromJson(item))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       print('Error searching cities: $e');
//       return [];
//     }
//   }
//
//   Future<List<City>> searchCitiesDebounced(
//       String query,
//       Duration delay,
//       ) async {
//     final completer = Completer<List<City>>();
//
//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(delay, () async {
//       final cities = await searchCities(query);
//       completer.complete(cities);
//     });
//
//     return completer.future;
//   }
//
//   void dispose() {
//     _debounceTimer?.cancel();
//   }
// }