import 'dart:convert';

import 'package:intl/intl.dart';

class Category {
  int id;
  String? name;
  List<String> images;
  List<String> activities;
  DateTime? updatedAt;
  DateTime? createdAt;

  Category({
    this.id = 0,
    this.name,
    this.images = const [],
    this.activities = const [],
    this.updatedAt,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      images: json['images'] != null
          ? List<String>.from(jsonDecode(json['images']))
          : [],
      activities: json['activities'] != null
          ? List<String>.from(jsonDecode(json['activities']))
          : [],
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'images': images,
        'activities': activities,
      };
}

class CategoryItem {
  int id;
  String name;
  int categoryId;
  int locationId;
  String? activity;
  String? address;
  String? urlLink;
  String? phone;
  String description;
  String? socialMediaLink;
  String? amount;
  List<String> images;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? updatedAt;
  DateTime? createdAt;
  bool madeByDetty;

  CategoryItem({
    this.id = 0,
    this.name = '',
    this.categoryId = 0,
    this.locationId = 0,
    this.activity,
    this.address,
    this.urlLink,
    this.phone,
    this.description = "",
    this.socialMediaLink,
    this.amount,
    this.images = const [''],
    this.madeByDetty = false,
    this.startDate,
    this.endDate,
    this.updatedAt,
    this.createdAt,
  });

  String get dateTimeRaw {
    if (startDate != null && endDate != null) {
      return "${DateFormat("hh:mmaa").format(startDate!)}-${DateFormat("hh:mmaa").format(endDate!)}"
          .toLowerCase();
    }
    if (startDate != null) {
      return DateFormat("EEE dd MMM, yyyy").format(startDate!);
    }
    return "";
  }

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    List<String> img = [''];
    try {
      img = json['images'] != null
          ? List<String>.from(jsonDecode(json['images']))
          : [];
      if (img.isEmpty) {
        img = [''];
      }
    } catch (e) {
      img = [''];
    }
    return CategoryItem(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryid'],
      locationId: json['locationid'],
      activity: json['activity'],
      address: json['address'],
      urlLink: json['urllink'],
      phone: json['phone'],
      description: json['description'],
      madeByDetty: json['isownedbydetty'] == 0 ? false : true,
      socialMediaLink: json['socialmedialink'],
      amount: json['amount'] ?? "0",
      images: img,
      startDate:
          json['startdate'] != null ? DateTime.parse(json['startdate']) : null,
      endDate: json['enddate'] != null ? DateTime.parse(json['enddate']) : null,
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'name': name,
        'categoryid': categoryId,
        'locationid': locationId,
        'activity': activity,
        'address': address,
        'urllink': urlLink,
        'phone': phone,
        'description': description,
        'socialmedialink': socialMediaLink,
        'amount': amount,
        'images': images,
        'startdate': startDate?.toIso8601String(),
        'enddate': endDate?.toIso8601String(),
      };
}

class Review {
  int id;
  String? description, username;
  int? categoryItemsId;
  double? rating;
  int? userId;
  DateTime? updatedAt;
  DateTime? createdAt;

  Review({
    this.id = 0,
    this.description,
    this.categoryItemsId,
    this.rating,
    this.userId,
    this.username,
    this.updatedAt,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      description: json['description'],
      categoryItemsId: json['categoryitemsid'],
      rating: json['rating']?.toDouble(),
      userId: json['userid'],
      username: json["username"],
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'categoryitemsid': categoryItemsId,
        'rating': rating,
        'userid': userId,
      };
}

class Favourite {
  int id;
  int? categoryItemsId;
  int? categoryId;
  int? userId;
  DateTime? updatedAt;
  DateTime? createdAt;

  Favourite({
    this.id = 0,
    this.categoryItemsId,
    this.categoryId,
    this.userId,
    this.updatedAt,
    this.createdAt,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['id'],
      categoryItemsId: json['categoryitemsid'],
      categoryId: json['categoryid'],
      userId: json['userid'],
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryitemsid': categoryItemsId,
        'categoryid': categoryId,
        'userid': userId,
      };
}


class Ads {
  int id;
  String name, desc, website;
  List<String> images;

  DateTime? updatedAt;
  DateTime? createdAt;

  Ads(
      {this.id = 0,
      this.name = "",
      this.desc = "",
      this.website = "",
      this.createdAt,
      this.updatedAt,
      this.images = const []});

factory Ads.fromJson(Map<String, dynamic> json) {
    List<String> img = [''];
    try {
      img = json['images'] != null
          ? List<String>.from(jsonDecode(json['images']))
          : [];
      if (img.isEmpty) {
        img = [''];
      }
    } catch (e) {
      img = [''];
    }
    return Ads(
      id: json['id'],
      name: json['name'],
      website: json['website'],
      desc: json['description'],
      images: img,
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

}
