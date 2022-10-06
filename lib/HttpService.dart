import 'dart:convert';
import 'package:http/http.dart';
import 'package:nasa_news/model/Article.dart';

import 'model/ImageGallery.dart';


class HttpService {
  final String postsURL = "http://images-api.nasa.gov/search?q=moon&page=1";

  Future<List<Item>> getData() async {
    var rest;
    var url = Uri.parse(postsURL);
    var res = await get(url);

    if (res.statusCode == 200) {
      rest=Article.fromJson(jsonDecode(res.body)).collection.items;
    }
    return rest!;
  }

  Future<List<String>> getImageGallery(String url) async {
    var rest;
    // var url = Uri.parse(url);
    var res = await get(Uri.parse(url));

    if (res.statusCode == 200) {
      // rest=Article.fromJson(jsonDecode(res.body)).collection.items;
      rest = imageGalleryFromJson(res.body);
    }
    return rest!;
  }

}
