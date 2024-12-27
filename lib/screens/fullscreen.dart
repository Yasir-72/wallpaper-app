import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class FullScreen extends StatefulWidget {
  final String imgUrl;

  FullScreen({Key? key, required this.imgUrl}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool isDownloading = false;

  Future<void> downloadImage(String imageUrl) async {
    try {
      setState(() {
        isDownloading = true;
      });

      String devicePathToSaveImage = "";
      var time = DateTime.now().microsecondsSinceEpoch;

      if (Platform.isAndroid) {
        //   devicePathToSaveImage = "/storage/emulated/0/Download/image-$time.jpg";
        // }
        // // else {
        var downloadDirectoryPath = await getApplicationDocumentsDirectory();
        devicePathToSaveImage = "${downloadDirectoryPath.path}/image-$time.jpg";
      }

      File file = File(devicePathToSaveImage);
      print('File path: $devicePathToSaveImage');

      // HTTP GET request to fetch the image
      var res = await get(Uri.parse(imageUrl));
      if (res.statusCode == 200) {
        // Save the image to the file
        await file.writeAsBytes(res.bodyBytes);

        // Save the image to the gallery
        await ImageGallerySaver.saveFile(devicePathToSaveImage);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Downloading Completed!!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to download image'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred during the download.'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isDownloading
            ? null
            : () {
                downloadImage(widget.imgUrl);
              },
        label: Text(
          isDownloading ? "Downloading..." : "Download",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        icon: const Icon(Icons.file_download, color: Colors.black),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.imgUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
