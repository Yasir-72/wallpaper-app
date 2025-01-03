import 'package:Wallify/widgets/info.dart';
import 'package:flutter/material.dart';
import 'package:Wallify/controller/apioper.dart';
import 'package:Wallify/modal/photosmodal.dart';
import 'package:Wallify/screens/fullscreen.dart';

class SearchPage extends StatefulWidget {
  final String query;
  SearchPage({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<PhotosModel> searchResults = [];
  bool isLoading = false;
  String errorMessage = "";

  Future<void> getSearchResults() async {
    if (widget.query.isEmpty) {
      setState(() {
        errorMessage = "Wallpaper not found"; // Display error for empty query
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true; // Start loading
      errorMessage = ""; // Clear error message
    });

    try {
      searchResults = await ApiOperartion.searchWallpapers(widget.query);
      if (searchResults.isEmpty) {
        setState(() {
          errorMessage = "No wallpapers found"; // No results
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch wallpapers"; // API error
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wallify",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 75, 85), // Vibrant pink-red
                Color.fromARGB(255, 255, 123, 150), // Soft coral pink
                Color.fromARGB(255, 129, 80, 209), // Rich purple
                Color.fromARGB(255, 67, 159, 247), // Vibrant blue
                Color.fromARGB(255, 49, 210, 255), // Aqua cyan
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Infopage();
                },
              );
            },
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF48FB1),
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
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
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 350,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return InkWell(
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
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image:
                                      NetworkImage(searchResults[index].imgSrc),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
