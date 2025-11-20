import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_detail.dart';

class PokemonTypeChip extends StatelessWidget {
  final PokemonType type;

  const PokemonTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getTypeColor(type.name),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getTypeColor(type.name).withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        type.capitalizedName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return const Color(0xFFFF6B6B);
      case 'water':
        return const Color(0xFF4D9DE0);
      case 'grass':
        return const Color(0xFF51CF66);
      case 'electric':
        return const Color(0xFFFABE2C);
      case 'psychic':
        return const Color(0xFFE64980);
      case 'ice':
        return const Color(0xFF74C0FC);
      case 'dragon':
        return const Color(0xFF5F3DC4);
      case 'dark':
        return const Color(0xFF495057);
      case 'fairy':
        return const Color(0xFFFF6BF7);
      case 'normal':
        return const Color(0xFFADB5BD);
      case 'fighting':
        return const Color(0xFFC92A2A);
      case 'flying':
        return const Color(0xFF748FFC);
      case 'poison':
        return const Color(0xFF9775FA);
      case 'ground':
        return const Color(0xFFF59F00);
      case 'rock':
        return const Color(0xFF868E96);
      case 'bug':
        return const Color(0xFF94D82D);
      case 'ghost':
        return const Color(0xFF6741D9);
      case 'steel':
        return const Color(0xFF495057);
      default:
        return Colors.grey;
    }
  }
}
