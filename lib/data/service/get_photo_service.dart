import 'package:dio/dio.dart';
import 'package:isolateapp/data/model/photo_model.dart';

class GetPhotoService {
  Future<dynamic> getService() async {
    try {
      Response response =
          await Dio().get("https://jsonplaceholder.typicode.com/photos");
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => PhotoModel.fromJson(e)).toList();
      } else {
        return response.statusMessage.toString();
      }
    } on DioError catch (e) {
      return e.error.toString();
    }
  }
}
