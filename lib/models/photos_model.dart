class PhotoModel {
  String url;
  String photographer;
  String photographerUrl;
  int photographerId;
  SrcModel src;

  PhotoModel(
      {this.url,
      this.photographer,
      this.photographerUrl,
      this.src,
      this.photographerId});

  factory PhotoModel.fromMap(Map<String, dynamic> parsedJson) {
    return PhotoModel(
        url: parsedJson["url"],
        photographer: parsedJson["photographer"],
        photographerId: parsedJson["photographer_id"],
        src: SrcModel.fromMap(parsedJson["src"]));
  }
}

class SrcModel {
  String portrait;
  String large;
  String landScape;
  String medium;

  SrcModel({this.portrait, this.large, this.landScape, this.medium});

  factory SrcModel.fromMap(Map<String, dynamic> srcJson) {
    return SrcModel(
        portrait: srcJson["portrait"],
        large: srcJson["large"],
        landScape: srcJson["landscape"],
        medium: srcJson["medium"]);
  }
}
