import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> downloadFile() async {
    Dio dio = Dio();
    try {
      Directory? downloadDirectory = await getDownloadsDirectory();
      String savePath = "${downloadDirectory!.path}/my_file.pdf";
      await dio.download("http://10.0.2.198:3000", savePath);
      return "File downloaded to : $savePath";
    } catch (e) {
      return "File not found $e";
    }
  }
}
