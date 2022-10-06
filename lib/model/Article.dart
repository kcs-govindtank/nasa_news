// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
  Article({
    required this.collection,
  });

  Collection collection;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    collection: Collection.fromJson(json["collection"]),
  );

  Map<String, dynamic> toJson() => {
    "collection": collection == null ? null : collection.toJson(),
  };
}

class Collection {
  Collection({
    required this.version,
    required this.href,
    required this.items,
  });

  String version;
  String href;
  List<Item> items=[];

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    version: json["version"] == null ? null : json["version"],
    href: json["href"] == null ? null : json["href"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "version": version == null ? null : version,
    "href": href == null ? null : href,
    "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    required this.href,
    required this.data,
    required this.links,
  });

  String href;
  List<Datum> data;
  List<Link> links;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    href: json["href"] == null ? null : json["href"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    links: json["links"] == null ? [] : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "links": links == null ? null : List<dynamic>.from(links.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.center,
    required this.title,
    required this.keywords,
    required this.nasaId,
    required this.dateCreated,
    required this.mediaType,
    required this.description,
  });

  String center;
  String title;
  List<String> keywords;
  String nasaId;
  DateTime dateCreated;
  String mediaType;
  String description;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    center: json["center"] == null ? null : json["center"],
    title: json["title"] == null ? null : json["title"],
    keywords: json["keywords"] == null ? [] : List<String>.from(json["keywords"].map((x) => x)),
    nasaId: json["nasa_id"] == null ? "null" : json["nasa_id"],
    dateCreated: json["date_created"] == null ? new DateTime.now() : DateTime.parse(json["date_created"]),
    mediaType: json["media_type"] == null ? null : json["media_type"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "center": center == null ? null : center,
    "title": title == null ? null : title,
    "keywords": keywords == null ? null : List<dynamic>.from(keywords.map((x) => x)),
    "nasa_id": nasaId == null ? null : nasaId,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "media_type": mediaType == null ? null : mediaType,
    "description": description == null ? null : description,
  };
}

class Link {
  Link({
    required this.href,
    required this.rel,
    required this.render,
  });

  String href;
  String rel;
  String render;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    href: json["href"] == null ? "null" : json["href"],
    rel: json["rel"] == null ? "null" : json["rel"],
    render: json["render"] == null ? "null" : json["render"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? "null" : href,
    "rel": rel == null ? "null" : rel,
    "render": render == null ? "null" : render,
  };
}
