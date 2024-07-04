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
  // ignore: prefer_const_constructors
  Icon visibleIcon = Icon(Icons.search);
  // ignore: prefer_const_constructors
  Widget searchBar = Text('Movies');

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
      movies = movies;
    });
  }

  Future search(text) async {
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget> [
          IconButton(
            padding: const EdgeInsets.only(right: 35),
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = const Icon(Icons.cancel);
                  searchBar = TextField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    onSubmitted: (String text) {
                      search(text);
                    },
                  );
                }
                else {
                  setState(() {
                    visibleIcon = const Icon(Icons.search);
                    searchBar = const Text('Movies');
                    // when pressing cancel button, go back to list of all movies
                    initialize();
                  });
                }
              });
            }
          ),
        ]),
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