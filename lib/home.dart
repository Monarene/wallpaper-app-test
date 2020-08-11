import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/models/categories_model.dart';
import 'package:wallpaper_app/models/photos_model.dart';
import 'package:wallpaper_app/view/categorie_screen.dart';
import 'package:wallpaper_app/view/search_view.dart';
import 'package:wallpaper_app/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = new List();

  int noOfImageToLoad = 30;
  List<PhotoModel> photos = new List();
  TextEditingController searchController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  getTrendingWallpaper() async {
    await http.get(
        "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);

      jsonData["photos"].forEach((element) {
        PhotoModel photoModel = new PhotoModel();
        photoModel = PhotoModel.fromMap(element);
        photos.add(photoModel);
      });

      setState(() {});
    });
  }

  @override
  void initState() {
    getTrendingWallpaper();
    categories = getCategories();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        getTrendingWallpaper();
      }
    });
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            hintText: "Search Wallpapers",
                            border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (searchController.text != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchView(
                                      search: searchController.text)));
                        }
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Taught By",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: "Overpass"),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchUrl("https://www.linkedin.com/in/Iamsanskar/");
                    },
                    child: Container(
                      child: Text(
                        "Sanskar Tiwari",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontFamily: "Overpass"),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 80,
                child: ListView.builder(itemBuilder: (context, index) {
                  return CategoriesTile(
                    imgUrls: categories[index].imgUrl,
                    categorie: categories[index].categorieName,
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  CategoriesTile({this.imgUrls, this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategorieScreen(categorie: categorie)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: kIsWeb
            ? Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            imgUrls,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: imgUrls,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      categorie,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Overpass"),
                    ),
                  )
                ],
              )
            : Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            imgUrls,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: imgUrls,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      categorie ?? "Yo yo ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Overpass"),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
