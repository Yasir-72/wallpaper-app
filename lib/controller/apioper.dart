import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/modal/categorymodal.dart';
import 'package:wallpaperapp/modal/photosmodal.dart';

List<PhotosModel> trendingWallpapers = [];
List<PhotosModel> searchWallpapersList = [];
List<CategoryModel> cateogryModelList = [];

class ApiOperartion {
  static Future<List<PhotosModel>> getTrendingWallpapers(
      {int totalImages = 200}) async {
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
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
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

  static List<CategoryModel> getCategoriesList() {
    List cateogryName = [
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
      "Fashion"
    ]; // Add more categories here
    cateogryModelList.clear();
    cateogryName.forEach((catName) async {
      final _random = Random();

      PhotosModel photoModel =
          (await searchWallpapers(catName))[0 + _random.nextInt(11 - 0)];
      cateogryModelList
          .add(CategoryModel(catImgUrl: photoModel.imgSrc, catName: catName));
    });

    return cateogryModelList;
  }
}
