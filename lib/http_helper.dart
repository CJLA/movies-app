import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=1393abe5b3ecc65fcb86c3fd7a9e94df';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  Future<List> getUpcoming() async {
    List movies = List.empty(growable: true);
    final Uri upcoming = Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);
    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      // VsCode really screwed me on this one. It suggested I change 'map' to 'Map' and it took me
      // a long time to debug the error
      movies = moviesMap.map((i) =>
      Movie.fromJson(i)).toList();
      return movies;
    }
    else {
      List<String> failedResponse = ['no results'];
      return failedResponse;
    }
  }
}