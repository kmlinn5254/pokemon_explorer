import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di_service.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../bloc/pokemon_detail/pokemon_detail_bloc.dart';
import '../bloc/pokemon_detail/pokemon_detail_event.dart';
import '../bloc/pokemon_detail/pokemon_detail_state.dart';
import '../widgets/pokemon_status_widget.dart';
import '../widgets/pokemon_type_chip.dart';
import '../widgets/pokemon_ability_card.dart';

class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailPage({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<PokemonDetailBloc>()..add(LoadPokemonDetail(pokemonId)),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
            builder: (context, state) {
              String title = 'Pokémon Explorer';

              if (state is PokemonDetailLoaded) {
                title = state.pokemon.capitalizedName;
              }

              if (state is PokemonDetailError) {
                title = 'Error';
              }

              return AppBar(
                title: Text(title),
                backgroundColor: (state is PokemonDetailLoaded)
                    ? _getTypeColor(state.pokemon.primaryType)
                    : Colors.blueAccent,
              );
            },
          ),
        ),

        body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PokemonDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PokemonDetailBloc>().add(
                          LoadPokemonDetail(pokemonId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is PokemonDetailLoaded) {
              return _buildDetailContent(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, PokemonDetailLoaded state) {
    final pokemon = state.pokemon;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PokemonDetailBloc>().add(RefreshPokemonDetail(pokemonId));
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.isOffline)
              Container(
                color: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.offline_bolt, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Offline Mode',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            if (pokemon.mainImageUrl.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Hero(
                    tag: 'pokemon_${pokemon.id}',
                    child: Image.file(
                      File(pokemon.mainImageUrl),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildNetworkImage(pokemon.mainImageUrl);
                      },
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID and Basic Info
                  _buildBasicInfo(pokemon),
                  const SizedBox(height: 24),

                  // Types
                  _buildSectionTitle('Types'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: pokemon.types
                        .map((type) => PokemonTypeChip(type: type))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  _buildSectionTitle('Stats'),
                  const SizedBox(height: 8),
                  PokemonStatsWidget(stats: pokemon.stats),
                  const SizedBox(height: 24),

                  // Abilities
                  _buildSectionTitle('Abilities'),
                  const SizedBox(height: 8),
                  ...pokemon.abilities
                      .map((ability) => PokemonAbilityCard(ability: ability))
                      .toList(),
                  const SizedBox(height: 24),

                  // Sprites Gallery
                  if (pokemon.sprites.allSprites.length > 1) ...[
                    _buildSectionTitle('Sprites'),
                    const SizedBox(height: 8),
                    _buildSpritesGallery(pokemon.sprites),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(PokemonDetail pokemon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  'ID',
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                ),
                _buildInfoItem('Height', pokemon.formattedHeight),
                _buildInfoItem('Weight', pokemon.formattedWeight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSpritesGallery(PokemonSprites sprites) {
    debugPrint('_buildSpritesGallery: ${sprites.allSprites}');
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sprites.allSprites.length,
        itemBuilder: (context, index) {
          debugPrint('_buildSpritesGallery: ${sprites.allSprites[index]}');
          return Container(
            margin: const EdgeInsets.only(right: 8),
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(sprites.allSprites[index]),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildNetworkImage(sprites.allSprites[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Center(
        child: Icon(Icons.catching_pokemon, size: 64, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget: (context, url, error) =>
          const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow[700]!;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.brown;
      case 'fairy':
        return Colors.pinkAccent;
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.red[900]!;
      case 'flying':
        return Colors.lightBlue;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown[300]!;
      case 'rock':
        return Colors.grey[700]!;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }
}
