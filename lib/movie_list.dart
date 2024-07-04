import 'package:flutter/material.dart';
import 'http_helper.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});
  
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final String iconBase = 'https://image.tmdb.org/t/p/w92';
  final String defaultImage = 
    'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184229.jpg';
  late NetworkImage image;
  late HttpHelper helper;
  int moviesCount = 0;
  List movies = List.empty(growable: true);
  // variable is used for debugging
  String count = '0';

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
          if (movies[position].posterPath != null) {
            image = NetworkImage(
              iconBase + movies[position].posterPath
            );
          }
          else {
            image = NetworkImage(defaultImage);
          }
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: image,
              ),
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