import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File?> compressImage(File file) async {
  final tempDir = await getTemporaryDirectory();
  final targetPath = p.join(
    tempDir.path,
    "${DateTime.now().millisecondsSinceEpoch}.jpg",
  );

  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 70, // 품질 70%
    minWidth: 1080, // 인스타그램 표준 가로 사이즈
    minHeight: 1080,
    format: CompressFormat.jpeg,
  );

  return result != null ? File(result.path) : null;
}
