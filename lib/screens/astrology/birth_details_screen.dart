import 'package:flutter/material.dart';
import '../../core/themes/app_theme.dart';
import '../../models/birth_details_model.dart';

class BirthDetailsScreen extends StatefulWidget {
  const BirthDetailsScreen({super.key});

  @override
  State<BirthDetailsScreen> createState() => _BirthDetailsScreenState();
}

class _BirthDetailsScreenState extends State<BirthDetailsScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _placeController = TextEditingController();
  bool _birthTimeUnknown = false;

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _generateKundali() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select birth date')),
      );
      return;
    }
    if (_placeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter birth place')),
      );
      return;
    }

    // Create birth details and generate kundali
    final unusedBirthDetails = BirthDetails(
      birthDate: _selectedDate!,
      birthTime: _birthTimeUnknown
          ? DateTime(2000, 1, 1, 12, 0)
          : DateTime(
              2000,
              1,
              1,
              _selectedTime?.hour ?? 12,
              _selectedTime?.minute ?? 0,
            ),
      birthPlace: _placeController.text,
      birthTimeUnknown: _birthTimeUnknown,
    );

    // TODO: Navigate to kundali display with generated data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birth Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Your Birth Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This information is required to generate your Janma Kundali',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            // Date picker
            _buildDatePicker(),
            const SizedBox(height: 24),
            // Time picker
            _buildTimePicker(),
            const SizedBox(height: 16),
            // Unknown time checkbox
            CheckboxListTile(
              title: const Text('Birth time unknown'),
              subtitle: const Text('Use 12:00 PM as default'),
              value: _birthTimeUnknown,
              onChanged: (value) {
                setState(() {
                  _birthTimeUnknown = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            // Place input
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: 'Birth Place',
                hintText: 'Enter your birthplace (City, Country)',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Generate button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _generateKundali,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Generate Kundali',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Birth Date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select date',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    if (_birthTimeUnknown) return const SizedBox.shrink();

    return InkWell(
      onTap: _selectTime,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Birth Time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select time',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
