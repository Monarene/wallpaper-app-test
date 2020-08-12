import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/models/photos_model.dart';
import 'package:wallpaper_app/widget/widget.dart';

class CategorieScreen extends StatefulWidget {
  final String categorie;

  CategorieScreen({this.categorie});

  @override
  _CategorieScreenState createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {
  List<PhotoModel> photos = new List();

  getCategories() async {
    await http.get(
        "https://api.pexels.com/v1/search?query=${widget.categorie}&per_page=30&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        PhotoModel photosModel = new PhotoModel();
        photosModel = PhotoModel.fromMap(element);
        photos.add(photosModel);
      });

      setState(() {});
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: wallPaper(photos, context),
      ),
    );
  }
}
