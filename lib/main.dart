import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}


Future<Album> fetchAlbum() async {
  final response = await 
      get(Uri.parse('https://api.openbrewerydb.org/v1/breweries/random'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
  
    throw Exception('Fehler beim laden');
  }
}

class Album {
  final String name;
  final String stadt;
  final String staat;

  const Album({
    required this.name,
    required this.stadt,
    required this.staat,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'Name': String name,
        'Stadt': String stadt,
        'Staat': String staat,
      } =>
        const Album(
          name: 'Name',
          stadt: 'Stadt',
          staat: 'Staat',
        ),
      _ => throw const FormatException('Fehler beim laden'),
    };
  }
}

//

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  
  var backgroundColor;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       backgroundColor:Colors.blueAccent,
       appBar: AppBar(backgroundColor: Colors.deepOrange,
        title: const Text('Brauereien'),
       ),
         body: Center(
              child: Padding(
            padding: const EdgeInsets.all(32.0),
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
              FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.name);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
              TextButton( 
             onPressed:() {},
             child: const Text('neu laden'),),
            ],
            ),                  
           ),
         ),          
        ),
    );
  }
}
