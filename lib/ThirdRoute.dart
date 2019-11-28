import 'package:flutter/material.dart';
import 'main.dart';
import 'PhotoRoute.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'dart:async';
import 'GoogleMapRoute.dart';

isNotNull(String word) {
  if (word != null)
    return word;
  else
    return " ";
}
isListCategoryNull(List<Category> list){
if(list.length==0)
  return " ";
else return list.elementAt(0).name;

}

class ThirdRoute extends StatelessWidget {
  Venue w;

  ThirdRoute(Venue w) {
    this.w = w;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(w.name),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              title: Text(
            "Adresse : " +
                isNotNull(w.location.address) +
                " " + /**/
                isNotNull(w.location.city) +
                " " +
                isNotNull(w.location.postalCode),
            style: Theme.of(context).textTheme.headline,
          )),
          ListTile(
              title: Text(
            "Categorie : " + isListCategoryNull(w.categories),
            style: Theme.of(context).textTheme.headline,
          )),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text(
              "Photo",
              style: Theme.of(context).textTheme.headline,
            ),
            onTap: () async {
              PhotoData data = photoDataFromJson(await getPhoto(w.id));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoRoute(data, w.name)),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GoogleMapRoute(
                      w.location.lat.toString(), w.location.lng.toString())),
            );
          },
          child: Icon(Icons.location_on),
        ),
      );

  }
}

Future<String> getPhoto(String ID) async {
  final response = await http.get('https://api.foursquare.com/v2/venues/' +
      ID +
      '/photos?limit=5' +
      '&client_id=' +
      client_id +
      '&client_secret=' +
      client_secret +
      '&v=20190923');

  if (response.statusCode == 200) {
    return response.body;
    // If server returns an OK response, parse the JSON.
    //return welcome;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

PhotoData photoDataFromJson(String str) => PhotoData.fromJson(json.decode(str));

String photoDataToJson(PhotoData data) => json.encode(data.toJson());

class PhotoData {
  MetaPhoto meta;
  ResponsePhoto response;

  PhotoData({
    this.meta,
    this.response,
  });

  factory PhotoData.fromJson(Map<String, dynamic> json) => PhotoData(
        meta: MetaPhoto.fromJson(json["meta"]),
        response: ResponsePhoto.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "response": response.toJson(),
      };
}

class MetaPhoto {
  int code;
  String requestId;

  MetaPhoto({
    this.code,
    this.requestId,
  });

  factory MetaPhoto.fromJson(Map<String, dynamic> json) => MetaPhoto(
        code: json["code"],
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "requestId": requestId,
      };
}

class ResponsePhoto {
  Photos photos;

  ResponsePhoto({
    this.photos,
  });

  factory ResponsePhoto.fromJson(Map<String, dynamic> json) => ResponsePhoto(
        photos: Photos.fromJson(json["photos"]),
      );

  Map<String, dynamic> toJson() => {
        "photos": photos.toJson(),
      };
}

class Photos {
  int count;
  List<Item> items;
  int dupesRemoved;

  Photos({
    this.count,
    this.items,
    this.dupesRemoved,
  });

  factory Photos.fromJson(Map<String, dynamic> json) => Photos(
        count: json["count"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        dupesRemoved: json["dupesRemoved"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "dupesRemoved": dupesRemoved,
      };
}

class Item {
  String id;
  int createdAt;
  Source source;
  String prefix;
  String suffix;
  int width;
  int height;
  User user;
  Checkin checkin;
  String visibility;

  Item({
    this.id,
    this.createdAt,
    this.source,
    this.prefix,
    this.suffix,
    this.width,
    this.height,
    this.user,
    this.checkin,
    this.visibility,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        createdAt: json["createdAt"],
        source: Source.fromJson(json["source"]),
        prefix: json["prefix"],
        suffix: json["suffix"],
        width: json["width"],
        height: json["height"],
        user: User.fromJson(json["user"]),
        checkin: Checkin.fromJson(json["checkin"]),
        visibility: json["visibility"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "source": source.toJson(),
        "prefix": prefix,
        "suffix": suffix,
        "width": width,
        "height": height,
        "user": user.toJson(),
        "checkin": checkin.toJson(),
        "visibility": visibility,
      };
}

class Checkin {
  String id;
  int createdAt;
  String type;
  int timeZoneOffset;

  Checkin({
    this.id,
    this.createdAt,
    this.type,
    this.timeZoneOffset,
  });

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
        id: json["id"],
        createdAt: json["createdAt"],
        type: json["type"],
        timeZoneOffset: json["timeZoneOffset"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "type": type,
        "timeZoneOffset": timeZoneOffset,
      };
}

class Source {
  String name;
  String url;

  Source({
    this.name,
    this.url,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class User {
  String id;
  String firstName;
  String lastName;
  String gender;
  Photo photo;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        gender: json["gender"],
        photo: Photo.fromJson(json["photo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "photo": photo.toJson(),
      };
}

class Photo {
  String prefix;
  String suffix;

  Photo({
    this.prefix,
    this.suffix,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        prefix: json["prefix"],
        suffix: json["suffix"],
      );

  Map<String, dynamic> toJson() => {
        "prefix": prefix,
        "suffix": suffix,
      };
}
