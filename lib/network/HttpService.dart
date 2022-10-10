import 'dart:convert';

import 'package:http/http.dart';
import 'package:nasa_news/model/Article.dart';

import '../model/ImageGallery.dart';


class HttpService {

  Future<Collection> getData(String linkURL) async {

    var rest;
    var url = Uri.parse(linkURL);
    var res = await get(url);
    print("url : $url");
    if (res.statusCode == 200) {
      rest=Article.fromJson(jsonDecode(res.body)).collection;

      print('result first title : ${(rest as Collection).items.first.data.first.title}');
    }
    return rest;
  }

  Future<List<String>> getImageGallery(String url) async {
    List<String> rest=[];
    var res = await get(Uri.parse(url));

    if (res.statusCode == 200) {
      rest = imageGalleryFromJson(res.body);
    }
    return rest;
  }

}
