import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:Wallify/modal/categorymodal.dart';
import 'package:Wallify/modal/photosmodal.dart';

List<PhotosModel> trendingWallpapers = [];
List<PhotosModel> searchWallpapersList = [];
List<CategoryModel> cateogryModelList = [];

class ApiOperartion {
  static Future<List<PhotosModel>> getTrendingWallpapers(
      {int totalImages = 500}) async {
    List<PhotosModel> trendingWallpapers = [];
    int perPage = 80; // Maximum allowed per page
    int totalPages =
        (totalImages / perPage).ceil(); // Calculate total pages needed

    try {
      for (int page = 1; page <= totalPages; page++) {
        final response = await http.get(
          Uri.parse(
              "https://api.pexels.com/v1/curated?per_page=$perPage&page=$page"),
          headers: {
            "Authorization":
                "wcTPHj1Q3qwWdrGFjiSHoU2uawGmxA7IQGH7C6FthDKjKdfxzzuxIMly"
          },
        );

        if (response.statusCode == 200) {
          // Parse JSON response
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          List photos = jsonData['photos'];

          // Add fetched photos to the trendingWallpapers list
          photos.forEach((element) {
            trendingWallpapers.add(PhotosModel.fromAPI2App(element));
          });

          // Stop fetching if we reach the total required images
          if (trendingWallpapers.length >= totalImages) break;
        } else {
          print('Failed to load wallpapers: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return trendingWallpapers.sublist(
        0, totalImages); // Return only the requested number of images
  }

  static Future<List<PhotosModel>> searchWallpapers(String query) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=400&page=1"),
        headers: {
          "Authorization":
              "wcTPHj1Q3qwWdrGFjiSHoU2uawGmxA7IQGH7C6FthDKjKdfxzzuxIMly"
        }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      searchWallpapersList.clear();
      photos.forEach((element) {
        searchWallpapersList.add(PhotosModel.fromAPI2App(element));
      });
    });

    return searchWallpapersList;
  }

  static Future<List<CategoryModel>> getCategoriesList() async {
    List<String> categoryNames = [
      "Cars",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "Flowers",
      "Animals",
      "Space",
      "Beaches",
      "Food",
      "Art",
      "Music",
      "Travel",
      "Sports",
    ]; // Add more categories here

    cateogryModelList.clear();
    List<CategoryModel> categoryModelList = [];
    for (var catName in categoryNames) {
      // Fetch 300 wallpapers for each category
      List<PhotosModel> categoryWallpapers = await searchWallpapers(catName);

      if (categoryWallpapers.isNotEmpty) {
        final _random = Random();
        PhotosModel photoModel =
            categoryWallpapers[_random.nextInt(categoryWallpapers.length)];

        categoryModelList.add(CategoryModel(
          catImgUrl: photoModel.imgSrc,
          catName: catName,
          wallpapers: categoryWallpapers,
        ));
      }
    }

    return categoryModelList;
  }
}
