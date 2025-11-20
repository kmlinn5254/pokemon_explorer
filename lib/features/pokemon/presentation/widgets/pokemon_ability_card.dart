import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_detail.dart';

class PokemonAbilityCard extends StatelessWidget {
  final PokemonAbility ability;

  const PokemonAbilityCard({super.key, required this.ability});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ability.isHidden ? Colors.purple : Colors.blue,
          child: Icon(
            ability.isHidden ? Icons.visibility_off : Icons.flash_on,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          ability.formattedName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          ability.isHidden ? 'Hidden Ability' : 'Normal Ability',
          style: TextStyle(
            color: ability.isHidden ? Colors.purple : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Slot ${ability.slot}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
