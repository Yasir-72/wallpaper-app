import 'package:flutter/material.dart';
import 'package:wallpaperapp/controller/apioper.dart';
import 'package:wallpaperapp/modal/photosmodal.dart';

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

  GetCatRelWall() async {
    categoryResults = await ApiOperartion.searchWallpapers(widget.catName);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCatRelWall();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Wallpaper App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      widget.catName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 350,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20), // Rounded edges
                      image: DecorationImage(
                        image: NetworkImage(categoryResults[index].imgSrc),
                        fit: BoxFit.cover,
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
