
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

_launchURL(String lat,String long) async {
  String url = 'https://www.google.com/maps/search/?api=1&query='+lat+','+long;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class GoogleMapRoute extends StatelessWidget {
  String lat;
  String long;

  GoogleMapRoute(String lat, String long) {
    this.lat=lat;
    this.long=long;
  }

  @override
  Widget build(BuildContext context) {
      _launchURL(lat,long);

    Navigator.pop(context);
    return new Scaffold(

    );

  }



}
