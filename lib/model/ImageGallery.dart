// To parse this JSON data, do
//
//     final imageGallery = imageGalleryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<String> imageGalleryFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String imageGalleryToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
