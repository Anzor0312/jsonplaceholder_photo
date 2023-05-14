import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:isolateapp/data/db/photo_db.dart';
import 'package:isolateapp/data/model/photo_model.dart';
import 'package:isolateapp/data/service/download_file.dart';
import 'package:isolateapp/data/service/get_photo_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Color"),
      ),
      body: FutureBuilder(
        future: PhotoRepository().chekDatabase(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data is String) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            List<PhotoModel> data = snapshot.data as List<PhotoModel>;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 600,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(data[index].url.toString()),fit: BoxFit.cover)
                    ),child: Text(data[index].title.toString()),
                  ),
                );
              },
              itemCount: data.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ReceivePort receivePort = ReceivePort();
          final isolate1 = await Isolate.spawn(_getFile, receivePort.sendPort);
          final isolate2 =
              await Isolate.spawn(_getCurrency, receivePort.sendPort);
          final result = await receivePort.take(2).toList();
          print(result);
          isolate1.kill();
          isolate2.kill();
        },
      ),
    );
  }
}

void _getFile(SendPort sendPort) async {
  sendPort.send(await FileService.downloadFile());
}

void _getCurrency(SendPort sendPort) async {
  sendPort.send(await GetPhotoService().getService());
}
