import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie_detail.dart';

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
          String releaseDate = movies[position].releaseDate;
          String voteAverage = movies[position].voteAverage.toString();
          // It was really bothering me when it would say "Released:" and the date was in the future.
          // The following lines check if the release date has come yet and if not it says, "Release Date:" instead.
          final DateTime convertedDate = DateTime.parse(releaseDate);
          final DateTime today = DateTime.now();
          final String releaseHeading = convertedDate.isAfter(today) ? 'Release Date' : 'Released';
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
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => MovieDetail(movie:movies[position]));
                Navigator.push(context, route);
              },
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              title: Text(movies[position].title),
              subtitle: Text('$releaseHeading: $releaseDate - Vote: $voteAverage'),
            )
          );
        })
    );
  }
}