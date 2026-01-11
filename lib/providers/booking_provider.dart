import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_models.dart';
import '../services/location_service.dart';

final locationServiceProvider = Provider((ref) => LocationService());

final bookingProvider =
StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(BookingState());

  void setTripType(TripType type) {
    state = state.copyWith(
      tripType: type,
      clearDropCity: type == TripType.local,
      clearReturnDate: type != TripType.roundTrip,
    );
  }

  void setAirportDirection(AirportDirection direction) {
    state = state.copyWith(airportDirection: direction);
  }

  void setPickupCity(City city) {
    state = state.copyWith(pickupCity: city);
  }

  void setDropCity(City city) {
    state = state.copyWith(dropCity: city);
  }

  void setPickupDate(DateTime date) {
    state = state.copyWith(pickupDate: date);
  }

  void setReturnDate(DateTime date) {
    state = state.copyWith(returnDate: date);
  }

  void setTime(String time) {
    state = state.copyWith(time: time);
  }

  void clearPickupCity() {
    state = state.copyWith(pickupCity: null);
  }

  void clearDropCity() {
    state = state.copyWith(clearDropCity: true);
  }

  String? validateForm() {
    if (state.pickupCity == null) {
      return 'Please select pickup city';
    }

    if (state.tripType != TripType.local &&
        state.tripType != TripType.airport &&
        state.dropCity == null) {
      return 'Please select drop city';
    }

    if (state.pickupDate == null) {
      return 'Please select pickup date';
    }

    if (state.tripType == TripType.roundTrip && state.returnDate == null) {
      return 'Please select return date';
    }

    if (state.time == null || state.time!.isEmpty) {
      return 'Please select time';
    }

    return null;
  }
}

final citySuggestionsProvider =
StateNotifierProvider<CitySuggestionsNotifier, AsyncValue<List<City>>>(
        (ref) {
      final locationService = ref.watch(locationServiceProvider);
      return CitySuggestionsNotifier(locationService);
    });

class CitySuggestionsNotifier extends StateNotifier<AsyncValue<List<City>>> {
  final LocationService _locationService;

  CitySuggestionsNotifier(this._locationService)
      : super(const AsyncValue.data([]));

  Future<void> searchCities(String query) async {
    if (query.isEmpty || query.length < 2) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final cities = await _locationService.searchCitiesDebounced(
        query,
        const Duration(milliseconds: 500),
      );
      state = AsyncValue.data(cities);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}