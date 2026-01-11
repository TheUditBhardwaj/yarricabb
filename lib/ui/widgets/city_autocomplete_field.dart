import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking_models.dart';
import '../../providers/booking_provider.dart';

class CityAutocompleteField extends ConsumerStatefulWidget {
  final String label;
  final IconData icon;
  final Function(City) onCitySelected;
  final City? selectedCity;
  final VoidCallback onClear;

  const CityAutocompleteField({
    super.key,
    required this.label,
    required this.icon,
    required this.onCitySelected,
    this.selectedCity,
    required this.onClear,
  });

  @override
  ConsumerState<CityAutocompleteField> createState() =>
      _CityAutocompleteFieldState();
}

class _CityAutocompleteFieldState extends ConsumerState<CityAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCity != null) {
      _controller.text = widget.selectedCity!.name;
    }
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CityAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCity != oldWidget.selectedCity) {
      _controller.text = widget.selectedCity?.name ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final citySuggestions = ref.watch(citySuggestionsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD3E8C5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (value) {
              setState(() {
                _showSuggestions = true;
              });
              ref.read(citySuggestionsProvider.notifier).searchCities(value);
            },
            onTap: () {
              setState(() {
                _showSuggestions = true;
              });
              if (_controller.text.isNotEmpty) {
                ref
                    .read(citySuggestionsProvider.notifier)
                    .searchCities(_controller.text);
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
                color: const Color(0xFF7CB342),
                size: isTablet ? 24 : 20,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.onClear();
                  ref.read(citySuggestionsProvider.notifier).clear();
                  setState(() {
                    _showSuggestions = false;
                  });
                },
              )
                  : null,
              hintText: widget.label,
              hintStyle: TextStyle(
                color: Colors.red[600],
                fontSize: isTablet ? 16 : 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 16 : 12,
              ),
            ),
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_showSuggestions) ...[
          citySuggestions.when(
            data: (cities) {
              if (cities.isEmpty && _controller.text.length >= 2) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Text('No cities found'),
                );
              }
              if (cities.isEmpty) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: cities.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_city,
                        size: isTablet ? 24 : 20,
                        color: const Color(0xFF7CB342),
                      ),
                      title: Text(
                        city.name,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        city.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 11,
                          color: Colors.red[600],
                        ),
                      ),
                      onTap: () {
                        _controller.text = city.name;
                        widget.onCitySelected(city);
                        setState(() {
                          _showSuggestions = false;
                        });
                        _focusNode.unfocus();
                      },
                    );
                  },
                ),
              );
            },
            loading: () => Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CB342)),
                  ),
                ),
              ),
            ),
            error: (error, stack) => Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                'Error loading cities',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ),
        ],
      ],
    );
  }
}