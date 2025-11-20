import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageOptimizationService {
  Future<String> optimizeAndCacheImage({
    required String imageUrl,
    required String savePath,
    required int targetWidth,
    required int targetHeight,
    int quality = 85,
  }) async {
    return compute(
      _processImage,
      ImageProcessParams(
        imageUrl: imageUrl,
        savePath: savePath,
        targetWidth: targetWidth,
        targetHeight: targetHeight,
        quality: quality,
      ),
    );
  }

  static Future<String> _processImage(ImageProcessParams params) async {
    // Download image
    final response = await HttpClient().getUrl(Uri.parse(params.imageUrl));
    final httpResponse = await response.close();
    final bytes = await consolidateHttpClientResponseBytes(httpResponse);

    // Decode image
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    // Resize
    final resized = img.copyResize(
      image,
      width: params.targetWidth,
      height: params.targetHeight,
      interpolation: img.Interpolation.linear,
    );

    // Compress to JPEG
    final jpeg = img.encodeJpg(resized, quality: params.quality);

    // Save
    final file = File(params.savePath);
    await file.writeAsBytes(jpeg);

    return params.savePath;
  }
}

class ImageProcessParams {
  final String imageUrl;
  final String savePath;
  final int targetWidth;
  final int targetHeight;
  final int quality;

  ImageProcessParams({
    required this.imageUrl,
    required this.savePath,
    required this.targetWidth,
    required this.targetHeight,
    required this.quality,
  });
}
