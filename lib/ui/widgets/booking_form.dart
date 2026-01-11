import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/booking_models.dart';
import '../../providers/booking_provider.dart';
import 'city_autocomplete_field.dart';

class BookingForm extends ConsumerWidget {
  BookingForm({super.key});

  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (bookingState.tripType == TripType.oneWay ||
              bookingState.tripType == TripType.roundTrip) ...[
            Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    context,
                    ref,
                    'One-way',
                    bookingState.tripType == TripType.oneWay,
                        () => ref
                        .read(bookingProvider.notifier)
                        .setTripType(TripType.oneWay),
                    isTablet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggleButton(
                    context,
                    ref,
                    'Round Trip',
                    bookingState.tripType == TripType.roundTrip,
                        () => ref
                        .read(bookingProvider.notifier)
                        .setTripType(TripType.roundTrip),
                    isTablet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (bookingState.tripType == TripType.airport) ...[
            Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    context,
                    ref,
                    'To The Airport',
                    bookingState.airportDirection == AirportDirection.toAirport,
                        () => ref
                        .read(bookingProvider.notifier)
                        .setAirportDirection(AirportDirection.toAirport),
                    isTablet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggleButton(
                    context,
                    ref,
                    'From The Airport',
                    bookingState.airportDirection ==
                        AirportDirection.fromAirport,
                        () => ref
                        .read(bookingProvider.notifier)
                        .setAirportDirection(AirportDirection.fromAirport),
                    isTablet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          CityAutocompleteField(
            label: bookingState.tripType == TripType.airport &&
                bookingState.airportDirection == AirportDirection.fromAirport
                ? 'Pickup Airport'
                : 'Pickup City',
            icon: Icons.location_on,
            onCitySelected: (city) {
              ref.read(bookingProvider.notifier).setPickupCity(city);
            },
            selectedCity: bookingState.pickupCity,
            onClear: () {
              ref.read(bookingProvider.notifier).clearPickupCity();
            },
          ),
          const SizedBox(height: 16),
          if (bookingState.tripType != TripType.local) ...[
            CityAutocompleteField(
              label: bookingState.tripType == TripType.airport &&
                  bookingState.airportDirection == AirportDirection.toAirport
                  ? 'Drop Airport'
                  : bookingState.tripType == TripType.local
                  ? 'Local Trip'
                  : 'Destination',
              icon: Icons.flag,
              onCitySelected: (city) {
                ref.read(bookingProvider.notifier).setDropCity(city);
              },
              selectedCity: bookingState.dropCity,
              onClear: () {
                ref.read(bookingProvider.notifier).clearDropCity();
              },
            ),
            const SizedBox(height: 16),
          ],
          if (bookingState.tripType == TripType.roundTrip)
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    context,
                    ref,
                    'From Date',
                    bookingState.pickupDate,
                        (date) => ref.read(bookingProvider.notifier).setPickupDate(date),
                    isTablet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    context,
                    ref,
                    'To Date',
                    bookingState.returnDate,
                        (date) => ref.read(bookingProvider.notifier).setReturnDate(date),
                    isTablet,
                  ),
                ),
              ],
            )
          else
            _buildDateField(
              context,
              ref,
              bookingState.tripType == TripType.airport
                  ? 'Pickup Date'
                  : 'Pick-up Date',
              bookingState.pickupDate,
                  (date) => ref.read(bookingProvider.notifier).setPickupDate(date),
              isTablet,
            ),
          const SizedBox(height: 16),
          _buildTimeField(context, ref, bookingState, isTablet),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final error =
                ref.read(bookingProvider.notifier).validateForm();
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Searching for cabs...'),
                      backgroundColor: Color(0xFF7CB342),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CB342),
                padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Explore Cabs',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      BuildContext context,
      WidgetRef ref,
      String label,
      bool isSelected,
      VoidCallback onTap,
      bool isTablet,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isTablet ? 14 : 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7CB342) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.red[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context,
      WidgetRef ref,
      String label,
      DateTime? selectedDate,
      Function(DateTime) onDateSelected,
      bool isTablet,
      ) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF7CB342),
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E8C5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.red[400],
              size: isTablet ? 24 : 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedDate)
                        : 'DD-MM-YYYY',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
      BuildContext context,
      WidgetRef ref,
      BookingState bookingState,
      bool isTablet,
      ) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF7CB342),
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          final formattedTime = time.format(context);
          _timeController.text = formattedTime;
          ref.read(bookingProvider.notifier).setTime(formattedTime);
        }
      },
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E8C5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.red[400],
              size: isTablet ? 24 : 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookingState.time ?? 'HH:MM',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}