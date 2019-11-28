import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'dart:async';
import 'dart:convert';
import 'SecondRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Rechercher un lieu'),
          ),
          body: MyCustomForm()),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  Widget buildlist(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10), helperText: "Lieu")),
            ),
            SizedBox(
              width: 20.0,
            ),
            new Flexible(
              child: new TextField(
                  controller: myController2,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      helperText: "Ce que vous cherchez")),
            ),
            SizedBox(
              width: 20.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Welcome welcome = welcomeFromJson(
              await fetchPost(myController.text, myController2.text));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute(welcome)),
          );
        },
        tooltip: 'Show me the venue!',
        child: Icon(Icons.search),
      ),
    );
  }
}

Future<String> fetchPost(String lieu, String theme) async {
  final response = await http.get(
      'https://api.foursquare.com/v2/venues/search?near=' +
          lieu +
          '&client_id=' +
          client_id +
          '&client_secret=' +
          client_secret +
          '&v=20190923&limit=30&query=' +
          theme);

  if (response.statusCode == 200) {
    return response.body;
    // If server returns an OK response, parse the JSON.
    //return welcome;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Meta meta;
  Response response;

  Welcome({
    this.meta,
    this.response,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        meta: Meta.fromJson(json["meta"]),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "response": response.toJson(),
      };
}

class Meta {
  int code;
  String requestId;

  Meta({
    this.code,
    this.requestId,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        code: json["code"],
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "requestId": requestId,
      };
}

class Response {
  List<Venue> venues;
  bool confident;
  Geocode geocode;

  Response({
    this.venues,
    this.confident,
    this.geocode,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        venues: List<Venue>.from(json["venues"].map((x) => Venue.fromJson(x))),
        confident: json["confident"],
        geocode: Geocode.fromJson(json["geocode"]),
      );

  Map<String, dynamic> toJson() => {
        "venues": List<dynamic>.from(venues.map((x) => x.toJson())),
        "confident": confident,
        "geocode": geocode.toJson(),
      };
}

class Geocode {
  String what;
  String where;
  Feature feature;
  List<dynamic> parents;

  Geocode({
    this.what,
    this.where,
    this.feature,
    this.parents,
  });

  factory Geocode.fromJson(Map<String, dynamic> json) => Geocode(
        what: json["what"],
        where: json["where"],
        feature: Feature.fromJson(json["feature"]),
        parents: List<dynamic>.from(json["parents"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "what": what,
        "where": where,
        "feature": feature.toJson(),
        "parents": List<dynamic>.from(parents.map((x) => x)),
      };
}

class Feature {
  Cc cc;
  String name;
  String displayName;
  String matchedName;
  String highlightedName;
  int woeType;
  String slug;
  String id;
  String longId;
  Geometry geometry;

  Feature({
    this.cc,
    this.name,
    this.displayName,
    this.matchedName,
    this.highlightedName,
    this.woeType,
    this.slug,
    this.id,
    this.longId,
    this.geometry,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        cc: ccValues.map[json["cc"]],
        name: json["name"],
        displayName: json["displayName"],
        matchedName: json["matchedName"],
        highlightedName: json["highlightedName"],
        woeType: json["woeType"],
        slug: json["slug"],
        id: json["id"],
        longId: json["longId"],
        geometry: Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "cc": ccValues.reverse[cc],
        "name": name,
        "displayName": displayName,
        "matchedName": matchedName,
        "highlightedName": highlightedName,
        "woeType": woeType,
        "slug": slug,
        "id": id,
        "longId": longId,
        "geometry": geometry.toJson(),
      };
}

enum Cc { FR }

final ccValues = EnumValues({"FR": Cc.FR});

class Geometry {
  Center1 center;
  Bounds bounds;

  Geometry({
    this.center,
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        center: Center1.fromJson(json["center"]),
        bounds: Bounds.fromJson(json["bounds"]),
      );

  Map<String, dynamic> toJson() => {
        "center": center.toJson(),
        "bounds": bounds.toJson(),
      };
}

class Bounds {
  Center1 ne;
  Center1 sw;

  Bounds({
    this.ne,
    this.sw,
  });

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        ne: Center1.fromJson(json["ne"]),
        sw: Center1.fromJson(json["sw"]),
      );

  Map<String, dynamic> toJson() => {
        "ne": ne.toJson(),
        "sw": sw.toJson(),
      };
}

class Center1 {
  double lat;
  double lng;

  Center1({
    this.lat,
    this.lng,
  });

  factory Center1.fromJson(Map<String, dynamic> json) => Center1(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Venue {
  String id;
  String name;
  Location location;
  List<Category> categories;
  ReferralId referralId;
  bool hasPerk;

  Venue({
    this.id,
    this.name,
    this.location,
    this.categories,
    this.referralId,
    this.hasPerk,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["id"],
        name: json["name"],
        location: Location.fromJson(json["location"]),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        referralId: referralIdValues.map[json["referralId"]],
        hasPerk: json["hasPerk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "referralId": referralIdValues.reverse[referralId],
        "hasPerk": hasPerk,
      };
}

class Category {
  String id;
  String name;
  String pluralName;
  String shortName;
  Imag icon;
  bool primary;

  Category({
    this.id,
    this.name,
    this.pluralName,
    this.shortName,
    this.icon,
    this.primary,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        pluralName: json["pluralName"],
        shortName: json["shortName"],
        icon: Imag.fromJson(json["icon"]),
        primary: json["primary"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pluralName": pluralName,
        "shortName": shortName,
        "icon": icon.toJson(),
        "primary": primary,
      };
}

class Imag {
  String prefix;
  String suffix;

  Imag({
    this.prefix,
    this.suffix,
  });

  factory Imag.fromJson(Map<String, dynamic> json) => Imag(
        prefix: json["prefix"],
        suffix: json["suffix"],
      );

  Map<String, dynamic> toJson() => {
        "prefix": prefix,
        "suffix": suffix,
      };
}

class Location {
  String address;
  double lat;
  double lng;
  List<LabeledLatLng> labeledLatLngs;
  String postalCode;
  Cc cc;
  String city;
  String state;
  Country country;
  List<String> formattedAddress;
  String crossStreet;

  Location({
    this.address,
    this.lat,
    this.lng,
    this.labeledLatLngs,
    this.postalCode,
    this.cc,
    this.city,
    this.state,
    this.country,
    this.formattedAddress,
    this.crossStreet,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        address: json["address"] == null ? null : json["address"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        labeledLatLngs: List<LabeledLatLng>.from(
            json["labeledLatLngs"].map((x) => LabeledLatLng.fromJson(x))),
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        cc: ccValues.map[json["cc"]],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: countryValues.map[json["country"]],
        formattedAddress:
            List<String>.from(json["formattedAddress"].map((x) => x)),
        crossStreet: json["crossStreet"] == null ? null : json["crossStreet"],
      );

  Map<String, dynamic> toJson() => {
        "address": address == null ? null : address,
        "lat": lat,
        "lng": lng,
        "labeledLatLngs":
            List<dynamic>.from(labeledLatLngs.map((x) => x.toJson())),
        "postalCode": postalCode == null ? null : postalCode,
        "cc": ccValues.reverse[cc],
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": countryValues.reverse[country],
        "formattedAddress": List<dynamic>.from(formattedAddress.map((x) => x)),
        "crossStreet": crossStreet == null ? null : crossStreet,
      };
}

enum Country { FRANCE }

final countryValues = EnumValues({"France": Country.FRANCE});

class LabeledLatLng {
  Label label;
  double lat;
  double lng;

  LabeledLatLng({
    this.label,
    this.lat,
    this.lng,
  });

  factory LabeledLatLng.fromJson(Map<String, dynamic> json) => LabeledLatLng(
        label: labelValues.map[json["label"]],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "label": labelValues.reverse[label],
        "lat": lat,
        "lng": lng,
      };
}

enum Label { DISPLAY }

final labelValues = EnumValues({"display": Label.DISPLAY});

enum ReferralId { V_1571836090 }

final referralIdValues = EnumValues({"v-1571836090": ReferralId.V_1571836090});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
