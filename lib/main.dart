import 'package:flutter/material.dart';
import 'movie_list.dart';
// import 'http_helper.dart';

void main() => runApp(const MyMovies());

class MyMovies extends StatelessWidget {
  const MyMovies({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
    
  @override
  Widget build(BuildContext context) {
    return const MovieList();
  }
}


