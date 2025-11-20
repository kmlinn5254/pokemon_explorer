import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pokemon.dart';
import '../pages/pokemon_detail_page.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailPage(pokemonId: pokemon.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey[200]!, Colors.grey[300]!],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'pokemon_${pokemon.id}',
                    child: pokemon.listPathUrl != null
                        ? Image.file(
                            File(pokemon.listPathUrl!),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildNetworkImage();
                            },
                          )
                        : _buildNetworkImage(),
                  ),
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pokemon.name.capitalize(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    if (pokemon.listPathUrl!.isEmpty) {
      return const Center(
        child: Icon(Icons.catching_pokemon, size: 64, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: pokemon.listPathUrl!,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget: (context, url, error) =>
          const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
