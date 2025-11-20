import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_explorer/core/services/image_optimization_service.dart';

void main() {
  late ImageOptimizationService service;

  setUp(() {
    service = ImageOptimizationService();
  });

  group('ImageOptimizationService', () {
    test('should create ImageProcessParams correctly', () {
      var params = ImageProcessParams(
        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png',
        savePath: '/path/to/save.jpg',
        targetWidth: 256,
        targetHeight: 256,
        quality: 85,
      );

      expect(params.imageUrl, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png');
      expect(params.savePath, '/path/to/save.jpg');
      expect(params.targetWidth, 256);
      expect(params.targetHeight, 256);
      expect(params.quality, 85);
    });

    test('should accept valid image dimensions', () {
      var params128 = ImageProcessParams(
        imageUrl: 'url',
        savePath: 'path',
        targetWidth: 128,
        targetHeight: 128,
        quality: 80,
      );

      var params256 = ImageProcessParams(
        imageUrl: 'url',
        savePath: 'path',
        targetWidth: 256,
        targetHeight: 256,
        quality: 85,
      );

      var params512 = ImageProcessParams(
        imageUrl: 'url',
        savePath: 'path',
        targetWidth: 512,
        targetHeight: 512,
        quality: 85,
      );

      expect(params128.targetWidth, 128);
      expect(params256.targetWidth, 256);
      expect(params512.targetWidth, 512);
    });

    test('should accept valid quality values', () {
      var params80 = ImageProcessParams(
        imageUrl: 'url',
        savePath: 'path',
        targetWidth: 256,
        targetHeight: 256,
        quality: 80,
      );

      var params85 = ImageProcessParams(
        imageUrl: 'url',
        savePath: 'path',
        targetWidth: 256,
        targetHeight: 256,
        quality: 85,
      );

      expect(params80.quality, 80);
      expect(params85.quality, 85);
    });
  });
}