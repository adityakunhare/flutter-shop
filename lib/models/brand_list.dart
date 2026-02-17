import 'dart:convert';

BrandList brandsFromJson(String str) => BrandList.fromJson(json.decode(str));

String brandsToJson(BrandList data) => json.encode(data.toJson());

class BrandList {
    List<Brand> data;

    BrandList({
        required this.data,
    });

    factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
        data: List<Brand>.from(json["data"].map((x) => Brand.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Brand {
    String type;
    int id;
    Attributes attributes;

    Brand({
        required this.type,
        required this.id,
        required this.attributes,
    });

    factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        type: json["type"],
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class Attributes {
    String title;

    Attributes({
        required this.title,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
    };
}
