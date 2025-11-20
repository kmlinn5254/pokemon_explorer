import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../di_service.dart';
import '../bloc/pokemon_list/pokemon_list_bloc.dart';
import '../bloc/pokemon_list/pokemon_list_event.dart';
import '../bloc/pokemon_list/pokemon_list_state.dart';
import '../widgets/pokemon_card.dart';

class PokemonListPage extends StatelessWidget {
  PokemonListPage({super.key});

  final _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PokemonListBloc>()..add(LoadPokemonList()),
      child: Scaffold(
        appBar: AppBar(title: Text('Pokémon Explorer')),
        body: BlocBuilder<PokemonListBloc, PokemonListState>(
          builder: (context, state) {
            if (state is PokemonListLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is PokemonListError) {
              return Center(child: Text(state.message));
            }

            if (state is PokemonListLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          Icon(
                            Icons.offline_bolt,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Offline Mode',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () async {
                        context.read<PokemonListBloc>().add(
                          RefreshPokemonList(),
                        );
                        _refreshController.refreshCompleted();
                      },
                      onLoading: () async {
                        context.read<PokemonListBloc>().add(LoadMorePokemon());
                        _refreshController.loadComplete();
                      },
                      child: GridView.builder(
                        padding: EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount:
                            state.pokemon.length +
                            (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= state.pokemon.length) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return PokemonCard(pokemon: state.pokemon[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}
