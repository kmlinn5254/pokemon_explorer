import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/image_optimization_service.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

enum ImageType {
  thumbnail('thumbnail'),
  list('list'),
  detail('detail');

  final String name;

  const ImageType(this.name);
}

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final ImageOptimizationService imageOptimizationService;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.imageOptimizationService,
  });

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    required int offset,
    required int limit,
    bool forceRefresh = false,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      List<PokemonModel> cachedPokemon = [];

      if (!forceRefresh) {
        try {
          cachedPokemon = await localDataSource.getCachedPokemonList(
            offset,
            limit,
          );
        } catch (_) {
          debugPrint('loading from cached database failed.');
        }
      }

      if (!isConnected) {
        if (cachedPokemon.isNotEmpty) {
          return Right(cachedPokemon.map((m) => m.toEntity()).toList());
        }
        return const Left(
          NetworkFailure('No internet connection and no cached data.'),
        );
      }

      final isListCacheExpired = !(await localDataSource.isListCacheValid());
      if (!forceRefresh && cachedPokemon.isNotEmpty && !isListCacheExpired) {
        return Right(cachedPokemon.map((m) => m.toEntity()).toList());
      }

      final remotePokemon = await remoteDataSource.getPokemonList(
        offset,
        limit,
      );

      await localDataSource.cachePokemonList(remotePokemon);
      _optimizeListImagesInBackground(remotePokemon);
      return Right(remotePokemon.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PokemonDetail>> getPokemonDetail({
    required int id,
    bool forceRefresh = false,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (!forceRefresh) {
        try {
          final isCacheValid = await localDataSource.isCacheValid(id);
          if (isCacheValid) {
            final cachedDetail = await localDataSource.getCachedPokemonDetail(
              id,
            );
            return Right(cachedDetail.toEntity());
          }
        } catch (_) {
          debugPrint('loading from cached database failed.');
        }
      }

      if (!isConnected) {
        try {
          final cachedDetail = await localDataSource.getCachedPokemonDetail(id);
          return Right(cachedDetail.toEntity());
        } catch (_) {
          return const Left(
            NetworkFailure('No internet connection and no cached data.'),
          );
        }
      }

      final remoteDetail = await remoteDataSource.getPokemonDetail(id);
      _optimizeDetailImagesInBackground(remoteDetail);
      await localDataSource.cachePokemonDetail(remoteDetail);
      return Right(remoteDetail.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshPokemonList() async {
    try {
      await localDataSource.clearCache();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  void _optimizeDetailImagesInBackground(
    PokemonDetailModel remoteDetail,
  ) async {
    try {
      final detailImagePath = await imageOptimizationService
          .optimizeAndCacheImage(
            imageUrl: remoteDetail.detailImagePath ?? "",
            savePath: await _getImagePath(
              remoteDetail.id.toString(),
              ImageType.detail.name,
            ),
            targetWidth: 512,
            targetHeight: 512,
            quality: 85,
          );

      final updatedSprites = Map<String, dynamic>.from(remoteDetail.sprites.toJson());

      for (final entry in updatedSprites.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String && value.startsWith('http')) {
          final filePath = await imageOptimizationService.optimizeAndCacheImage(
            imageUrl: value,
            savePath: await _getImagePath(
              key.toString(),
              ImageType.thumbnail.name,
            ),
            targetWidth: 128,
            targetHeight: 128,
            quality: 80,
          );
          updatedSprites[key] = filePath;
        }
      }

      final updatedDetail = remoteDetail.copyWith(
        sprites: PokemonSpritesModel.fromJson(updatedSprites),
        detailImagePath: detailImagePath,
      );

      await localDataSource.updatePokemonDetail(updatedDetail);
    } catch (e) {
      debugPrint('Failed to optimize image for ${remoteDetail.name}: $e');
    }
  }

  void _optimizeListImagesInBackground(List<PokemonModel> pokemon) async {
    for (final poke in pokemon) {
      if (poke.listPathUrl != null) {
        try {
          final listImagePath = await imageOptimizationService
              .optimizeAndCacheImage(
                imageUrl: poke.listPathUrl!,
                savePath: await _getImagePath(
                  poke.id.toString(),
                  ImageType.list.name,
                ),
                targetWidth: 256,
                targetHeight: 256,
                quality: 85,
              );

          await localDataSource.updatePokemonImagePaths(poke.id, listImagePath);
        } catch (e) {
          debugPrint('Failed to optimize image for ${poke.name}: $e');
        }
      }
    }
  }

  Future<String> _getImagePath(String id, String type) async {
    final directory = await getApplicationDocumentsDirectory();

    final imagesDir = Directory('${directory.path}/pokemon_images/$type');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return '${directory.path}/pokemon_images/$type/$id.jpg';
  }
}
