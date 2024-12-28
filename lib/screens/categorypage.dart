import 'package:Wallify/widgets/info.dart';
import 'package:flutter/material.dart';
import 'package:Wallify/controller/apioper.dart';
import 'package:Wallify/modal/photosmodal.dart';
import 'package:Wallify/screens/fullscreen.dart';

// ignore: must_be_immutable
class CategoryPage extends StatefulWidget {
  String catName;
  String catImgUrl;

  CategoryPage({super.key, required this.catImgUrl, required this.catName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<PhotosModel> categoryResults = [];
  bool isLoading = true;

  // Fetch category-related wallpapers
  GetCatRelWall() async {
    categoryResults = await ApiOperartion.searchWallpapers(widget.catName);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    GetCatRelWall();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Category Banner with Name
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.catImgUrl,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      widget.catName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Loading or No Results
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFF48FB1),
                    ),
                  )
                : categoryResults.isEmpty
                    ? const Center(
                        child: Text(
                          "No wallpapers found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
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
                            mainAxisExtent: 350,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: categoryResults.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                    imgUrl: categoryResults[index].imgSrc,
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
                                    categoryResults[index].imgSrc,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
