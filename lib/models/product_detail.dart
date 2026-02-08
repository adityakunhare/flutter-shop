// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    Data data;

    Product({
        required this.data,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    String type;
    int id;
    Attributes attributes;

    Data({
        required this.type,
        required this.id,
        required this.attributes,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    String imageUrl;
    int price;
    List<int> sizes;
    List<String> colors;
    String category;
    String brand;

    Attributes({
        required this.title,
        required this.imageUrl,
        required this.price,
        required this.sizes,
        required this.colors,
        required this.category,
        required this.brand,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        title: json["title"],
        imageUrl: json["imageURL"],
        price: json["price"],
        sizes: List<int>.from(json["sizes"].map((x) => x)),
        colors: List<String>.from(json["colors"].map((x) => x)),
        category: json["category"],
        brand: json["brand"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "imageURL": imageUrl,
        "price": price,
        "sizes": List<dynamic>.from(sizes.map((x) => x)),
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "category": category,
        "brand": brand,
    };
}
