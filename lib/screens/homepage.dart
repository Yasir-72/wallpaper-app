import 'package:Wallify/widgets/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Wallify/controller/apioper.dart';
import 'package:Wallify/modal/categorymodal.dart';
import 'package:Wallify/modal/photosmodal.dart';
import 'package:Wallify/screens/fullscreen.dart';
import 'package:Wallify/widgets/catblock.dart';
import 'package:Wallify/widgets/searchbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<PhotosModel> trendingWallList = [];
  late List<CategoryModel> CatModList = [];

  bool isLoading = true;

  GetCatDetails() async {
    CatModList =
        (await ApiOperartion.getCategoriesList()).cast<CategoryModel>();
    print("GETTTING CAT MOD LIST");
    print(CatModList);
    setState(() {
      CatModList = CatModList;
    });
  }

  GetTrendingWalpaper() async {
    trendingWallList = await ApiOperartion.getTrendingWallpapers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCatDetails();
    GetTrendingWalpaper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wallify",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.pink[200], // Optional: Add color to the loader
              ),
            )
          : trendingWallList.isEmpty
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
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SearchBarComponent(),
                      )),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: CatModList.length, // Use CatModList length
                          itemBuilder: ((context, index) => CatBlock(
                                categoryImgSrc: CatModList[index].catImgUrl,
                                categoryName: CatModList[index].catName,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 350,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: trendingWallList.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullScreen(
                                            imgUrl: trendingWallList[index]
                                                .imgSrc)));
                              },
                              child: Hero(
                                tag: trendingWallList[index].imgSrc,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded edges
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          trendingWallList[index].imgSrc),
                                      fit: BoxFit.cover,
                                    ),
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