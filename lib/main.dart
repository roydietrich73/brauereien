import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}


Future<List<Album>> fetchAlbum() async {
  final response = await 
      get(Uri.parse('https://api.openbrewerydb.org/v1/breweries/random'));
     

  if (response.statusCode == 200) {
    return [Album.fromJson(jsonDecode(response.body)[0] as Map<String, dynamic>)];
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
    Album album = Album(name: json["name"], stadt: json["city"], staat: json["state"]);
    return album;
  }
}

//

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
 late Future<List<Album>> album = fetchAlbum();

  @override
  void initState() {
    super.initState();
    getAlbumFromAPI();
  }

  Future<void> getAlbumFromAPI() async {
      album = Future(fetchAlbum);
      print("Führe methode aus!");
    setState((){
   
    });
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
              FutureBuilder<List<Album>>(
              future: album,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data![0];
                  return Text("${data.name} lebt in ${data.stadt}, ${data.staat}");
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
              const SizedBox(height: 30,),
              TextButton( 
              onPressed:() => getAlbumFromAPI(),
              child: const Text('neu laden'),),
             ],
            ),
          ),
        ),
      ),
    );
  }
}
