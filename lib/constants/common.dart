import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';

class CM {

  static Options cacheOptions(){
    return buildCacheOptions(const Duration(days: 1),forceRefresh: true,
        maxStale: const Duration(days: 2));
  }

  static Future<bool> isInternetAvailable() async {
    bool isConnected=false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isConnected=true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return isConnected;
  }


  static Container loading(){
    return Container(alignment: Alignment.center,
        child: Icon(Icons.downloading_outlined));
  }
}