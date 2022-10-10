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
    "collection": collection.toJson(),
  };
}

class Collection {
  Collection({
    required this.version,
    required this.href,
    required this.items,
    required this.metadata,
    required this.links,
  });

  String version;
  String href;
  List<Item> items;
  Metadata metadata;
  List<CollectionLink> links;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    version: json["version"],
    href: json["href"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    metadata: Metadata.fromJson(json["metadata"]),
    links: List<CollectionLink>.from(json["links"].map((x) => CollectionLink.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "href": href,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "metadata": metadata.toJson(),
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
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
  List<ItemLink> links;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    href: json["href"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    links: json["links"] == null ? [] : List<ItemLink>.from(json["links"].map((x) => ItemLink.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
    required this.description508,
    required this.secondaryCreator,
    required this.location,
    required this.photographer,
    required this.album,
  });

  Center center;
  String title;
  List<String> keywords;
  String nasaId;
  DateTime dateCreated;
  MediaType mediaType;
  String description;
  String description508;
  String secondaryCreator;
  String location;
  String photographer;
  List<String> album;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    center: centerValues.map[json["center"]]??Center.ARC,
    title: json["title"],
    keywords: json["keywords"]== null ?[] : List<String>.from(json["keywords"].map((x) => x)),
    nasaId: json["nasa_id"],
    dateCreated: DateTime.parse(json["date_created"]),
    mediaType: mediaTypeValues.map[json["media_type"]]??MediaType.IMAGE,
    description: json["description"],
    description508: json["description_508"] == null ? "" : json["description_508"],
    secondaryCreator: json["secondary_creator"] == "" ? null : json["secondary_creator"],
    location: json["location"] == null ? "" : json["location"],
    photographer: json["photographer"] == null ? "" : json["photographer"],
    album: json["album"] == null ? [] : List<String>.from(json["album"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "center": centerValues.reverse[center],
    "title": title,
    "keywords": List<dynamic>.from(keywords.map((x) => x)),
    "nasa_id": nasaId,
    "date_created": dateCreated.toIso8601String(),
    "media_type": mediaTypeValues.reverse[mediaType],
    "description": description,
    "description_508": description508 == null ? "" : description508,
    "secondary_creator": secondaryCreator == null ? "" : secondaryCreator,
    "location": location == null ? "" : location,
    "photographer": photographer == null ? "" : photographer,
    "album": album == null ? [] : List<dynamic>.from(album.map((x) => x)),
  };
}

enum Center { HQ, JPL, JSC, GSFC, ARC }

final centerValues = EnumValues({
  "ARC": Center.ARC,
  "GSFC": Center.GSFC,
  "HQ": Center.HQ,
  "JPL": Center.JPL,
  "JSC": Center.JSC
});

enum MediaType { VIDEO, IMAGE, AUDIO }

final mediaTypeValues = EnumValues({
  "audio": MediaType.AUDIO,
  "image": MediaType.IMAGE,
  "video": MediaType.VIDEO
});

class ItemLink {
  ItemLink({
    required this.href,
    required this.rel,
    required this.render,
  });

  String href;
  Rel rel;
  MediaType render;

  factory ItemLink.fromJson(Map<String, dynamic> json) => ItemLink(
    href: json["href"],
    rel: relValues.map[json["rel"]]??Rel.PREVIEW,
    render: mediaTypeValues.map[json["render"]]??MediaType.IMAGE,
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "rel": relValues.reverse[rel],
    "render": render == null ? null : mediaTypeValues.reverse[render],
  };
}

enum Rel { PREVIEW, CAPTIONS }

final relValues = EnumValues({
  "captions": Rel.CAPTIONS,
  "preview": Rel.PREVIEW
});

class CollectionLink {
  CollectionLink({
    required this.rel,
    required this.prompt,
    required this.href,
  });

  String rel;
  String prompt;
  String href;

  factory CollectionLink.fromJson(Map<String, dynamic> json) => CollectionLink(
    rel: json["rel"],
    prompt: json["prompt"],
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "rel": rel,
    "prompt": prompt,
    "href": href,
  };
}

class Metadata {
  Metadata({
    required this.totalHits,
  });

  int totalHits;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    totalHits: json["total_hits"],
  );

  Map<String, dynamic> toJson() => {
    "total_hits": totalHits,
  };
}

class EnumValues<T> {
  Map<String, T> map=new Map();
  Map<T, String> reverseMap=new Map();

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
