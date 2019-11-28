import 'package:calexis_projet/ThirdRoute.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PhotoRoute extends StatelessWidget {
  PhotoData data;
  String venueName;
  List<String> urlphoto;

  PhotoRoute(PhotoData data, String venueName) {
    this.data = data;
    this.venueName = venueName;
    urlphoto = new List<String>();
  }

  @override
  Widget build(BuildContext context) {
    data.response.photos.items.forEach(
        (photo) => urlphoto.add(photo.prefix + "300x300" + photo.suffix));
    if (urlphoto.length > 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Photo"),
          ),
          body: CarouselSlider(
            enableInfiniteScroll: true,
            height: 400.0,
            items: urlphoto.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(url))),
                  );
                },
              );
            }).toList(),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Photo"),
          ),
          body: Center(
            child: Text(
              "Aucune Photo 😔",
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ));
    }
  }
}
