import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7CB342),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 12 : 8,
            horizontal: isTablet ? 24 : 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                imagePath: 'assets/images/icons/home.png',
                label: 'Home',
                isSelected: true,
                isTablet: isTablet,
              ),
              _buildNavItem(
                imagePath: 'assets/images/icons/trip.png',
                label: 'My Trip',
                isSelected: false,
                isTablet: isTablet,
              ),
              _buildNavItem(
                imagePath: 'assets/images/icons/acc.png',
                label: 'Account',
                isSelected: false,
                isTablet: isTablet,
              ),
              _buildNavItem(
                imagePath: 'assets/images/icons/more.png',
                label: 'More',
                isSelected: false,
                isTablet: isTablet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required String label,
    required bool isSelected,
    required bool isTablet,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: isTablet ? 28 : 24,
          height: isTablet ? 28 : 24,
          color: isSelected ? Colors.black : Colors.white,
        ),
        SizedBox(height: isTablet ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black54,
            fontSize: isTablet ? 14 : 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}