import 'package:flutter/material.dart';
import 'package:wallpaperapp/controller/apioper.dart';
import 'package:wallpaperapp/modal/photosmodal.dart';
import 'package:wallpaperapp/screens/fullscreen.dart';
import 'package:wallpaperapp/widgets/searchbar.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  String query;
  SearchPage({super.key, required this.query});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<PhotosModel> searchResults = [];
  bool isLoading = true;

  GetSearchResults() async {
    searchResults = await ApiOperartion.searchWallpapers(widget.query);
    setState(() {
      isLoading = false; // Data has been loaded
    });
  }

  @override
  void initState() {
    super.initState();
    GetSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Wallpaper App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.orange, // Optional: Add color to the loader
              ),
            )
          : searchResults.isEmpty
              ? Center(
                  child: Text(
                    "No wallpapers found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 350,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreen(
                                      imgUrl: searchResults[index].imgSrc,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        searchResults[index].imgSrc),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
