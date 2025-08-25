import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // State variables for filter values
  RangeValues _priceRange = const RangeValues(10, 80);
  final Set<String> _selectedDiets = {'Vegetarian'};
  int _selectedSortBy = 0; // 0: Top Rated, 1: Fastest, 2: Most Popular

  @override
  Widget build(BuildContext context) {
    // === YEH RAHA BADLAV ===
    // Humne poore content ko Material widget se wrap kar diya hai.
    // Isse ChoiceChip aur FilterChip ko zaroori Material parent mil jayega.
    return Material(
      // Sheet ka background color yahan set karein
      color: Colors.white,
      // borderRadius ko yahan se hata dein kyunki parent container mein hai
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 24),

            // Sections
            _buildSectionTitle('Sort by'),
            _buildSortByChips(),
            const SizedBox(height: 24),

            _buildSectionTitle('Dietary'),
            _buildDietaryChips(),
            const SizedBox(height: 24),

            _buildSectionTitle('Price Range'),
            _buildPriceRangeSlider(),
            const SizedBox(height: 40),

            _buildApplyButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Filters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {
            // Reset all filters
            setState(() {
              _priceRange = const RangeValues(10, 80);
              _selectedDiets.clear();
              _selectedSortBy = 0;
            });
          },
          child: const Text('Reset', style: TextStyle(color: Color(0xFFF3A938), fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A)));
  }

  Widget _buildSortByChips() {
    final options = ['Top Rated', 'Fastest', 'Most Popular'];
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(
        spacing: 12.0,
        children: List.generate(options.length, (index) {
          return ChoiceChip(
            label: Text(options[index]),
            selected: _selectedSortBy == index,
            onSelected: (selected) {
              setState(() {
                _selectedSortBy = index;
              });
            },
            selectedColor: Colors.orange.withOpacity(0.2),
            labelStyle: TextStyle(color: _selectedSortBy == index ? Colors.orange.shade800 : Colors.black87),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(color: _selectedSortBy == index ? Colors.orange : Colors.grey.shade300),
          );
        }),
      ),
    );
  }

  Widget _buildDietaryChips() {
    final options = ['Vegetarian', 'Vegan', 'Gluten-Free', 'Halal'];
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(
        spacing: 12.0,
        children: options.map((diet) {
          final isSelected = _selectedDiets.contains(diet);
          return FilterChip(
            label: Text(diet),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedDiets.add(diet);
                } else {
                  _selectedDiets.remove(diet);
                }
              });
            },
            selectedColor: Colors.orange.withOpacity(0.2),
            checkmarkColor: Colors.orange.shade800,
            labelStyle: TextStyle(color: isSelected ? Colors.orange.shade800 : Colors.black87),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(color: isSelected ? Colors.orange : Colors.grey.shade300),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 100,
          divisions: 10,
          activeColor: const Color(0xFFF3A938),
          inactiveColor: Colors.orange.withOpacity(0.2),
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_priceRange.start.round()}'),
              Text('\$${_priceRange.end.round()}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Logic to apply filters and close the sheet
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF3A938),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}