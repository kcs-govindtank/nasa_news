import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/common.dart';
import '../model/ImageGallery.dart';

class HttpService {
  Future<List<String>> getImageGallery(Dio dio, String url) async {
    List<String> rest=[];
    try{
      var URL=Uri.parse(url);
      print(URL);
      var res = await dio.getUri(URL,options: CM.cacheOptions());
      if (res.statusCode == 200) {
        rest = imageGalleryFromJson(jsonEncode(res.data));
      }
    }catch(e){
      print(e);
    }
    return rest;
  }
}
