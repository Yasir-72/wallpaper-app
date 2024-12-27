import 'package:flutter/material.dart';
import 'package:wallpaperapp/screens/categorypage.dart';

// ignore: must_be_immutable
class CatBlock extends StatefulWidget {
  String categoryName;
  String categoryImgSrc;
  CatBlock(
      {super.key, required this.categoryImgSrc, required this.categoryName});

  @override
  State<CatBlock> createState() => _CatBlockState();
}

class _CatBlockState extends State<CatBlock> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryPage(
                    catImgUrl: widget.categoryImgSrc,
                    catName: widget.categoryName)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                  widget.categoryImgSrc),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(
                left: 30,
                top: 15,
                child: Text(
                  widget.categoryName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
