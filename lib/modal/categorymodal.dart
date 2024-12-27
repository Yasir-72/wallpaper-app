import 'package:Wallify/modal/photosmodal.dart';

class CategoryModel {
  String catName;
  String catImgUrl;
  List<PhotosModel> wallpapers; // Added list of wallpapers

  CategoryModel({
    required this.catImgUrl,
    required this.catName,
    required this.wallpapers, // Initialize with a list of wallpapers
  });

  // Updated method to handle the new data structure
  static CategoryModel fromApi2App(Map<String, dynamic> category, List<PhotosModel> wallpapers) {
    return CategoryModel(
      catImgUrl: category["imgUrl"],
      catName: category["CategoryName"],
      wallpapers: wallpapers, // Include the list of wallpapers
    );
  }
}
