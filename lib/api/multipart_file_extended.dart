import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class MultipartFileExtended extends MultipartFile {
  final String filePath;

  MultipartFileExtended(
    super.stream,
    super.length, {
    required this.filePath,
    super.filename,
    super.contentType,
    super.headers,
  });

  static MultipartFileExtended fromFileSync(
    String filePath, {
    required String filename,
    MediaType? contentType,
  }) => multipartFileFromPathSync(
    filePath,
    filename: filename,
    contentType: contentType,
  );
}

MultipartFileExtended multipartFileFromPathSync(
  String filePath, {
  required String filename,
  MediaType? contentType,
}) {
  filename = p.basename(filePath);
  var file = File(filePath);
  var length = file.lengthSync();
  var stream = file.openRead();
  return MultipartFileExtended(
    stream,
    length,
    filename: filename,
    contentType: contentType,
    filePath: filePath,
  );
}
