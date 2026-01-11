import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking_models.dart';
import '../../providers/booking_provider.dart';
import '../widgets/trip_type_tabs.dart';
import '../widgets/booking_form.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isTablet),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPromoCard(context, isTablet),
                    const SizedBox(height: 16),
                    const TripTypeTabs(),
                    const SizedBox(height: 16),
                    BookingForm(),
                    const SizedBox(height: 16),
                    _buildIllustration(context, isTablet),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/img.png',
              height: isTablet ? 100 : 70,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            iconSize: isTablet ? 28 : 24,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "India's Leading ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 30 : 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "Inter-City",
                style: TextStyle(
                  color: const Color(0xFF7CB342),
                  fontSize: isTablet ? 30 : 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "One Way ",
                style: TextStyle(
                  color: const Color(0xFF7CB342),
                  fontSize: isTablet ? 30 : 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Cab Service Provider",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 30 : 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ), SizedBox(height: isTablet ? 16 : 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/img_2.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/img_1.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}