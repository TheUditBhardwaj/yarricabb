enum TripType { oneWay, roundTrip, local, airport }

enum AirportDirection { toAirport, fromAirport }

class City {
  final String name;
  final String displayName;
  final double lat;
  final double lon;

  City({
    required this.name,
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '0') ?? 0,
      lon: double.tryParse(json['lon']?.toString() ?? '0') ?? 0,
    );
  }
}

class BookingState {
  final TripType tripType;
  final AirportDirection airportDirection;
  final City? pickupCity;
  final City? dropCity;
  final DateTime? pickupDate;
  final DateTime? returnDate;
  final String? time;
  final bool isLoading;
  final String? error;

  BookingState({
    this.tripType = TripType.oneWay,
    this.airportDirection = AirportDirection.toAirport,
    this.pickupCity,
    this.dropCity,
    this.pickupDate,
    this.returnDate,
    this.time,
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    TripType? tripType,
    AirportDirection? airportDirection,
    City? pickupCity,
    City? dropCity,
    DateTime? pickupDate,
    DateTime? returnDate,
    String? time,
    bool? isLoading,
    String? error,
    bool clearDropCity = false,
    bool clearReturnDate = false,
  }) {
    return BookingState(
      tripType: tripType ?? this.tripType,
      airportDirection: airportDirection ?? this.airportDirection,
      pickupCity: pickupCity ?? this.pickupCity,
      dropCity: clearDropCity ? null : (dropCity ?? this.dropCity),
      pickupDate: pickupDate ?? this.pickupDate,
      returnDate: clearReturnDate ? null : (returnDate ?? this.returnDate),
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isValid {
    switch (tripType) {
      case TripType.oneWay:
        return pickupCity != null &&
            dropCity != null &&
            pickupDate != null &&
            time != null;
      case TripType.roundTrip:
        return pickupCity != null &&
            dropCity != null &&
            pickupDate != null &&
            returnDate != null &&
            time != null;
      case TripType.local:
        return pickupCity != null && pickupDate != null && time != null;
      case TripType.airport:
        return pickupCity != null && pickupDate != null && time != null;
    }
  }
}