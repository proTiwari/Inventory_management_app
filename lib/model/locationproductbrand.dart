// To parse this JSON data, do
//
//     final locationproductbrand = locationproductbrandFromJson(jsonString);

import 'dart:convert';

Locationproductbrand locationproductbrandFromJson(String str) => Locationproductbrand.fromJson(json.decode(str));

String locationproductbrandToJson(Locationproductbrand data) => json.encode(data.toJson());

class Locationproductbrand {
    LocationA? locationA;

    Locationproductbrand({
        this.locationA,
    });

    factory Locationproductbrand.fromJson(Map<String, dynamic> json) => Locationproductbrand(
        locationA: json["locationA"] == null ? null : LocationA.fromJson(json["locationA"]),
    );

    Map<String, dynamic> toJson() => {
        "locationA": locationA?.toJson(),
    };
}

class LocationA {
    List<String>? productname;

    LocationA({
        this.productname,
    });

    factory LocationA.fromJson(Map<String, dynamic> json) => LocationA(
        productname: json["productname"] == null ? [] : List<String>.from(json["productname"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "productname": productname == null ? [] : List<dynamic>.from(productname!.map((x) => x)),
    };
}
