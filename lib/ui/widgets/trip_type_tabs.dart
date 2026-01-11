// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/booking_models.dart';
// import '../../providers/booking_provider.dart';
//
// class TripTypeTabs extends ConsumerWidget {
//   const TripTypeTabs({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bookingState = ref.watch(bookingProvider);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;
//
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final buttonWidth = (constraints.maxWidth) / 3;
//
//           return Row(
//             children: [
//               _buildTab(
//                 context,
//                 ref,
//                 'Outstation Trip',
//                 Icons.map_outlined,
//                 TripType.oneWay,
//                 bookingState.tripType == TripType.oneWay,
//                 buttonWidth,
//                 isTablet,
//               ),
//               const SizedBox(width: 12),
//
//               _buildTab(
//                 context,
//                 ref,
//                 'Local Trip',
//                 Icons.location_city,
//                 TripType.local,
//                 bookingState.tripType == TripType.local,
//                 buttonWidth,
//                 isTablet,
//               ),
//               const SizedBox(width: 12),
//               _buildTab(
//                 context,
//                 ref,
//                 'Airport Transfer',
//                 Icons.flight,
//                 TripType.airport,
//                 bookingState.tripType == TripType.airport,
//                 buttonWidth,
//                 isTablet,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTab(
//       BuildContext context,
//       WidgetRef ref,
//       String label,
//       IconData icon,
//       TripType type,
//       bool isSelected,
//       double width,
//       bool isTablet,
//       ) {
//     return Flexible(
//       child: GestureDetector(
//         onTap: () {
//           ref.read(bookingProvider.notifier).setTripType(type);
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             vertical: isTablet ? 16 : 12,
//             horizontal: isTablet ? 12 : 8,
//           ),
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFF7CB342) : Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected ? const Color(0xFF7CB342) : Colors.grey[300]!,
//               width: 1,
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 color: isSelected ? Colors.white : Colors.grey[700],
//                 size: isTablet ? 28 : 24,
//               ),
//               SizedBox(height: isTablet ? 6 : 4),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.grey[700],
//                   fontSize: isTablet ? 12 : 10,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking_models.dart';
import '../../providers/booking_provider.dart';

class TripTypeTabs extends ConsumerWidget {
  const TripTypeTabs({super.key});

  static const Color _activeColor = Color(0xFF7CB342);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final tabs = [
      _TripTabData(
        label: 'Outstation Trip',
        imagePath: 'assets/images/icons/img.png',
        type: TripType.oneWay,
      ),
      _TripTabData(
        label: 'Local Trip',
        imagePath: 'assets/images/icons/img_1.png',
        type: TripType.local,
      ),
      _TripTabData(
        label: 'Airport Transfer',
        imagePath: 'assets/images/icons/img_2.png',
        type: TripType.airport,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = bookingState.tripType == tab.type;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _TripTab(
                label: tab.label,
                imagePath: tab.imagePath,
                isSelected: isSelected,
                isTablet: isTablet,
                onTap: () {
                  ref
                      .read(bookingProvider.notifier)
                      .setTripType(tab.type);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// ================= TAB WIDGET =================

class _TripTab extends StatelessWidget {
  const _TripTab({
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    required this.isTablet,
  });

  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTablet;

  static const Color _activeColor = Color(0xFF7CB342);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? _activeColor : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? _activeColor : Colors.grey.shade300,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: _activeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 16 : 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  height: isTablet ? 28 : 24,
                  width: isTablet ? 28 : 24,
                  color: isSelected
                      ? Colors.white
                      : Colors.grey.shade700,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= TAB MODEL =================

class _TripTabData {
  final String label;
  final String imagePath;
  final TripType type;

  const _TripTabData({
    required this.label,
    required this.imagePath,
    required this.type,
  });
}