// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaperapp/screens/searchpage.dart';

class SearchBarComponent extends StatelessWidget {
  SearchBarComponent({super.key});

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Color.fromARGB(66, 192, 192, 192),
            border: Border.all(color: Color.fromARGB(33, 13, 5, 5)),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Wallpapers",
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchPage(query: _searchController.text)));
                },
                child: Icon(Icons.search))
          ],
        ));
  }
}
