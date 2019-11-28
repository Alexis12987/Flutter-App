import 'package:flutter/material.dart';
import 'main.dart';
import 'ThirdRoute.dart';

class SecondRoute extends StatelessWidget {
  Welcome w;

  SecondRoute(Welcome w) {
    this.w = w;
  }

  Widget _buildList(BuildContext context,int index) {

      if (!w.response.venues.elementAt(index).categories.isEmpty){
        return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(w.response.venues
                  .elementAt(index)
                  .categories
                  .first
                  .icon
                  .prefix +
                  "64" +
                  w.response.venues
                      .elementAt(index)
                      .categories
                      .first
                      .icon
                      .suffix), // no matter how big it is, it won't overflow
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThirdRoute(w.response.venues.elementAt(index))),
              );
            },
            title: Text(
              w.response.venues.elementAt(index).name,
              style: Theme.of(context).textTheme.headline,
            ));
      }
       return ListTile(
          leading: CircleAvatar(
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ThirdRoute(w.response.venues.elementAt(index))),
            );
          },
          title: Text(
            w.response.venues.elementAt(index).name,
            style: Theme.of(context).textTheme.headline,
          ));



  }

  @override
  Widget build(BuildContext context) {
    if (w.response.venues.length !=0) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Resultat"),
          ),
          body: ListView.builder(
              itemCount: w.response.venues.length,
              itemBuilder: (context, index) {
                return _buildList(context,index);
              }));
    }else{
      return Scaffold(
          appBar: AppBar(
            title: Text("Resultat"),
          ),
          body: Center(
            child: Text("Aucun Resultat 😔",
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),

          )
      );
    }
  }
}
