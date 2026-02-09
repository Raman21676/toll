import 'package:flutter/material.dart';
import '../../core/themes/app_theme.dart';
import '../../models/janma_kundali_model.dart';

class KundaliDisplayScreen extends StatelessWidget {
  final JanmaKundali? kundali;
  
  const KundaliDisplayScreen({super.key, this.kundali});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Janma Kundali'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share kundali
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Download kundali
            },
          ),
        ],
      ),
      body: kundali == null
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Birth details card
                  _buildBirthDetailsCard(),
                  const SizedBox(height: 24),
                  // Kundali chart visualization (placeholder)
                  _buildKundaliChart(),
                  const SizedBox(height: 24),
                  // Rashi and Nakshatra info
                  _buildRashiInfo(),
                  const SizedBox(height: 24),
                  // Planetary positions
                  _buildPlanetaryPositions(),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Kundali Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate your kundali first',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to birth details
            },
            child: const Text('Generate Kundali'),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Birth Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Date:', '${kundali!.birthDate.day}/${kundali!.birthDate.month}/${kundali!.birthDate.year}'),
            _buildDetailRow('Time:', '${kundali!.birthTime.hour}:${kundali!.birthTime.minute.toString().padLeft(2, '0')}'),
            _buildDetailRow('Place:', kundali!.birthPlace),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKundaliChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Birth Chart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for kundali chart
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Kundali Chart\n(Visualization Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRashiInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Rashi (Moon Sign)',
            kundali!.rashi,
            Icons.circle,
            AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Nakshatra',
            kundali!.nakshatra,
            Icons.star,
            AppTheme.accentGold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetaryPositions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Planetary Positions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...kundali!.planets.entries.map((entry) {
              final planet = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: _getPlanetColor(planet.planet),
                  child: Text(
                    planet.planet[0],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(planet.planet),
                subtitle: Text('${planet.rashi} (${planet.house}th House)'),
                trailing: Text(
                  '${planet.degreeInRashi.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getPlanetColor(String planet) {
    switch (planet) {
      case 'Sun':
        return Colors.orange;
      case 'Moon':
        return Colors.grey;
      case 'Mars':
        return Colors.red;
      case 'Mercury':
        return Colors.green;
      case 'Jupiter':
        return Colors.yellow.shade700;
      case 'Venus':
        return Colors.pink;
      case 'Saturn':
        return Colors.blueGrey;
      case 'Rahu':
        return Colors.purple;
      case 'Ketu':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
