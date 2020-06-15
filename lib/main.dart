import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJSON();
  List _features = _data["features"];

  runApp(MaterialApp(
    title: "Earth Quake App",
    home: Scaffold(
      appBar: AppBar(
        title: Text("Quake App"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: _features.length,
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: <Widget>[
              Divider(
                height: 5.0,
              ),
              ListTile(
                title: Text(
                  timeFormat(_features, position),
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(_features[position]["properties"]["place"]),
                leading: CircleAvatar(
                  child: Text(
                    _features[position]["properties"]["mag"].toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
                onTap: () => alertBox(
                    context, _features[position]["properties"]["title"]),
              )
            ],
          );
        },
      ),
    ),
  ));
}

void alertBox(BuildContext context, String message) {
  var alertDialog = new AlertDialog(
    title: Text("Quakes"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
          onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
    ],
  );
  showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      });
}

String timeFormat(List _features, int position) {
  DateTime date;
  var format;
  date = new DateTime.fromMillisecondsSinceEpoch(
      (_features[position]["properties"]["time"]));
  format = new DateFormat('MMMM d, y HH:mm a');
  //              OR
//  format = new DateFormat.yMMMMd('en_US').add_jm();

  var dateString = format.format(date);
  return dateString;
}

Future<Map> getJSON() async {
  String apiURL =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiURL);

  return json.decode(response.body);
}
