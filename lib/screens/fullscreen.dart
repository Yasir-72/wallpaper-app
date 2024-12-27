import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  final String imgUrl;

  FullScreen({Key? key, required this.imgUrl}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<String?> downloadImage(String url) async {
    // Mock implementation
    return "path_to_downloaded_image";
  }

  // void showWallpaperOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               "Set Wallpaper",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const Divider(),
  //             ListTile(
  //               leading: const Icon(Icons.home, color: Colors.orange),
  //               title: const Text("Home Screen"),
  //               onTap: () => Navigator.pop(context),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.lock, color: Colors.orange),
  //               title: const Text("Lock Screen"),
  //               onTap: () => Navigator.pop(context),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.phone_android, color: Colors.orange),
  //               title: const Text("Both Screens"),
  //               onTap: () => Navigator.pop(context),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Spacing from the left
          FloatingActionButton.extended(
            onPressed: () {
              
            },
            label: const Text("Download" , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold, color: Colors.black),),
            icon: const Icon(Icons.file_download, color: Colors.black,),
            backgroundColor: Colors.orange,
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
