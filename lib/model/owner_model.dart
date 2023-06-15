// To parse this JSON data, do
//
//     final ownerModel = ownerModelFromJson(jsonString);

import 'dart:convert';

OwnerModel ownerModelFromJson(String str) =>
    OwnerModel.fromJson(json.decode(str));

String ownerModelToJson(OwnerModel data) => json.encode(data.toJson());
String locationToJson(Location data) => json.encode(data.toJson());

class OwnerModel {
  List<Location>? locations;
  List<dynamic>? customer;
  String? uid;
  String? email;
  String? accountcreatedon;

  OwnerModel({
    this.locations,
    this.customer,
    this.uid,
    this.email,
    this.accountcreatedon,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        locations: json["locations"] == null
            ? []
            : List<Location>.from(
                json["locations"]!.map((x) => Location.fromJson(x))),
        customer: json["customer"] == null
            ? []
            : List<dynamic>.from(json["customer"]!.map((x) => x)),
        uid: json["uid"],
        email: json["email"],
        accountcreatedon: json["accountcreatedon"],
      );

  Map<String, dynamic> toJson() => {
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "customer":
            customer == null ? [] : List<dynamic>.from(customer!.map((x) => x)),
        "uid": uid,
        "email": email,
        "accountcreatedon": accountcreatedon,
      };
}

class Location {
  String? locationName;
  Product? product;
  List<History>? history;

  Location({
    this.locationName,
    this.product,
    this.history,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationName: json["locationName"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        history: json["history"] == null
            ? []
            : List<History>.from(
                json["history"]!.map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "locationName": locationName,
        "product": product?.toJson(),
        "history": history == null
            ? []
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  String? status;
  String? quantity;
  String? datetime;
  String? type;
  String? initialquantity;
  String? finalquantity;
  String? customername;
  String? lotid;
  String? description;
  String? pname;
  String? brand;

  History({
    this.status,
    this.quantity,
    this.datetime,
    this.type,
    this.initialquantity,
    this.finalquantity,
    this.customername,
    this.lotid,
    this.brand,
    this.description,
    this.pname,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        status: json["status"],
        quantity: json["quantity"],
        datetime: json["datetime"],
        type: json["type"],
        initialquantity: json["initialquantity"],
        finalquantity: json["finalquantity"],
        customername: json["customername"],
        lotid: json["lotid"],
        description: json["description"],
        pname: json["pname"],
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "quantity": quantity,
        "datetime": datetime,
        "type": type,
        "initialquantity": initialquantity,
        "finalquantity": finalquantity,
        "customername": customername,
        "lotid": lotid,
        "pname": pname,
        "brand": brand,
        "description": description,
      };
}

class Product {
  String? pname;
  String? lotid;
  String? quantity;
  String? category;
  String? datetime;
  String? brand;
  String? description;

  Product({
    this.pname,
    this.lotid,
    this.quantity,
    this.category,
    this.datetime,
    this.brand,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        pname: json["pname"],
        lotid: json["lotid"],
        quantity: json["quantity"],
        category: json["category"],
        datetime: json["datetime"],
        brand: json["brand"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "pname": pname,
        "lotid": lotid,
        "quantity": quantity,
        "category": category,
        "datetime": datetime,
        "brand": brand,
        "description": description,
      };
}
