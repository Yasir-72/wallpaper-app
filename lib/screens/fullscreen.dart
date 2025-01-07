import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:http/http.dart';

import 'package:path_provider/path_provider.dart';

class FullScreen extends StatefulWidget {
  final String imgUrl;

  FullScreen({Key? key, required this.imgUrl}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool isDownloading = false;
  bool isSettingWallpaper = false;

  Future<void> setWallpaper(String imageUrl, int wallpaperLocation) async {
    try {
      setState(() {
        isSettingWallpaper = true;
      });

      // Download the image to a temporary location
      var res = await get(Uri.parse(imageUrl));
      if (res.statusCode == 200) {
        var tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/temp_wallpaper.jpg';
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(res.bodyBytes);

        // Set the wallpaper
        bool result = await WallpaperManager.setWallpaperFromFile(
          tempPath,
          wallpaperLocation,
        );

        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wallpaper set successfully!'),
          ));
        } else {
          throw Exception("Failed to set wallpaper.");
        }
      } else {
        throw Exception("Failed to download image for wallpaper.");
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while setting the wallpaper.'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isSettingWallpaper = false;
      });
    }
  }

  void showWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Set as Wallpaper",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.orange,
                ),
                title: Text(
                  "Home Screen",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setWallpaper(widget.imgUrl, WallpaperManager.HOME_SCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock,color: Colors.orange,),
                title: const Text("Lock Screen",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  setWallpaper(widget.imgUrl, WallpaperManager.LOCK_SCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallpaper,color: Colors.orange,),
                title: const Text("Both Screens",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  setWallpaper(widget.imgUrl, WallpaperManager.BOTH_SCREEN);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: isDownloading
                ? null
                : () async {
                    setState(() {
                      isDownloading = true;
                    });
                    var res = await get(Uri.parse(widget.imgUrl));
                    if (res.statusCode == 200) {
                      var tempDir = await getTemporaryDirectory();
                      String tempPath = '${tempDir.path}/downloaded_image.jpg';
                      File tempFile = File(tempPath);
                      await tempFile.writeAsBytes(res.bodyBytes);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Image downloaded successfully!'),
                      ));
                    }
                    setState(() {
                      isDownloading = false;
                    });
                  },
            label: Text(
              isDownloading ? "Downloading..." : "Download",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            icon: const Icon(Icons.file_download, color: Colors.black),
            backgroundColor: Color(0xFFFFB341),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: isSettingWallpaper ? null : showWallpaperOptions,
            label: Text(
              isSettingWallpaper ? "Setting..." : "Set Wallpaper",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            icon: const Icon(Icons.wallpaper, color: Colors.black),
            backgroundColor: Color(0xFFFFB341),
          ),
        ],
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
