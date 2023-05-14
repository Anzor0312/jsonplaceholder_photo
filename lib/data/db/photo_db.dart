import 'dart:io';

import 'package:isar/isar.dart';
import 'package:isolateapp/data/model/photo_model.dart';
import 'package:isolateapp/data/service/get_photo_service.dart';
import 'package:path_provider/path_provider.dart';

class PhotoRepository {
  late Isar db;
  GetPhotoService getPhotoService = GetPhotoService();
  Future<dynamic> chekDatabase() async {
    
    db = await openIsar();
    if (await db.photoModels.count() == 0) {
      return getPhoto();
    } else {
      return await db.photoModels.where().findAll();
    }
  }

  Future<dynamic> getPhoto() async {
    return await getPhotoService.getService().then((dynamic response) async{
      if (response is List<PhotoModel>) {
      db=await  openIsar();
        writeToDatabase(response);
        return db.photoModels.where().findAll();
      } else {
        return response;
      }
    });
  }

  Future<Isar> openIsar() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.openSync([PhotoModelSchema], directory: appDocDir.path);
    } else {
      return await Future.value(Isar.getInstance());
    }
  }

  Future<void> writeToDatabase(List<PhotoModel> data) async {
    final isar = db;
    isar.writeTxn(() async {
      await isar.clear();
      await isar.photoModels.putAll(data);
    });
  }
}
