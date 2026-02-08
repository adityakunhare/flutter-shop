// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
    List<SingleProduct> data;
    Links links;
    Meta meta;

    Products({
        required this.data,
        required this.links,
        required this.meta,
    });

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        data: List<SingleProduct>.from(json["data"].map((x) => SingleProduct.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
    };
}

class SingleProduct {
    Type type;
    int id;
    Attributes attributes;

    SingleProduct({
        required this.type,
        required this.id,
        required this.attributes,
    });

    factory SingleProduct.fromJson(Map<String, dynamic> json) => SingleProduct(
        type: typeValues.map[json["type"]]!,
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class Attributes {
    String title;
    String imageUrl;
    int price;
    Category category;
    String brand;

    Attributes({
        required this.title,
        required this.imageUrl,
        required this.price,
        required this.category,
        required this.brand,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        title: json["title"],
        imageUrl: json["imageURL"],
        price: json["price"],
        category: categoryValues.map[json["category"]]!,
        brand: json["brand"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "imageURL": imageUrl,
        "price": price,
        "category": categoryValues.reverse[category],
        "brand": brand,
    };
}

enum Category {
    FISHING,
    RUNNING,
    TREKKING
}

final categoryValues = EnumValues({
    "fishing": Category.FISHING,
    "running": Category.RUNNING,
    "trekking": Category.TREKKING
});

enum Type {
   singleProduct 
}

final typeValues = EnumValues({
    "product": Type.singleProduct
});

class Links {
    dynamic first;
    dynamic last;
    dynamic prev;
    String next;

    Links({
        required this.first,
        required this.last,
        required this.prev,
        required this.next,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    String path;
    int perPage;
    String nextCursor;
    dynamic prevCursor;

    Meta({
        required this.path,
        required this.perPage,
        required this.nextCursor,
        required this.prevCursor,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        path: json["path"],
        perPage: json["per_page"],
        nextCursor: json["next_cursor"],
        prevCursor: json["prev_cursor"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
        "per_page": perPage,
        "next_cursor": nextCursor,
        "prev_cursor": prevCursor,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
