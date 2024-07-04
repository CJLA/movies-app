import 'package:flutter/material.dart';
import 'http_helper.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});
  
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late HttpHelper helper;
  int moviesCount = 0;
  // variable is used for debugging
  String count = '0';
  List movies = List.empty(growable: true);

  @override 
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future initialize() async {
   movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      // used for debugging
      count = moviesCount.toString();
      movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies $count'),),
      body: ListView.builder(
        itemCount: moviesCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(movies[position].title),
              subtitle: Text('Released: '
              + movies[position].releaseDate + ' - Vote: '
              + movies[position].voteAverage.toString()),
            )
          );
        })
    );
  }
}