import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Beer Listing',
    home: new MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Beer>> _getBeers() async {
    var data = await http.get('https://api.punkapi.com/v2/beers');
    var jsonData = json.decode(data.body);
    List<Beer> beers = [];

    for (var b in jsonData) {
      Beer beer = Beer(
          b['id'], b['name'], b['tagline'], b['image_url'], b['first_brewed']);
      beers.add(beer);
    }
    print(beers);
    return beers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: new Text(
          'Top Beers',
          style: new TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getBeers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: new Center(
                    child: new Text(
                      'Loading...',
                      style: new TextStyle(
                        color: Colors.amber,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int pos) {
                      return ListTile(
                        leading: new Image.network(
                          snapshot.data[pos].image_url,
                          width: 70.0,
                          height: 60.0,
                        ),
                        title: Text(
                          snapshot.data[pos].name,
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(snapshot.data[pos].tagline),
                        trailing: Column(
                          children: <Widget>[
                            Text(
                              'Brewed:',
                              style: new TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              snapshot.data[pos].first_brewed,
                              style: new TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}

//model class for Beers
class Beer {
  final int id;
  final String name;
  final String tagline;
  final String image_url;
  final String first_brewed;

  Beer(this.id, this.name, this.tagline, this.image_url, this.first_brewed);
}
