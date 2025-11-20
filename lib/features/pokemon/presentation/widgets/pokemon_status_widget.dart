import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_detail.dart';

class PokemonStatsWidget extends StatelessWidget {
  final List<PokemonStat> stats;

  const PokemonStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: stats.map((stat) => _buildStatBar(stat)).toList(),
        ),
      ),
    );
  }

  Widget _buildStatBar(PokemonStat stat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                stat.baseStat.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: stat.percentage,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatColor(stat.baseStat),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatColor(int value) {
    if (value >= 100) {
      return Colors.green;
    } else if (value >= 70) {
      return Colors.lightGreen;
    } else if (value >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
