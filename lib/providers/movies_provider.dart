import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/actor_movies_response.dart';
import 'package:movies_app/models/actor_response.dart';
import 'package:movies_app/models/credits_response.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/now_playing_response.dart';
import 'package:movies_app/models/popular_response.dart';
import 'package:movies_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier{

  String _apiKey = '55e2a9e248a03d89a352cabbc872c194';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> upcomingMovies = [];
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;
  int _onDisplayPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500)
  );
  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;


  MoviesProvider(){
    print('Movies Provider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
    this.getUpomingMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1])async{
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }

  getPopularMovies() async {
    _popularPage++;

    final response = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson( response);

    popularMovies = [ ...popularMovies, ...popularResponse.results];
    // print(popularMovies);
    notifyListeners();
  }
  getUpomingMovies() async {
    final response = await _getJsonData('3/movie/upcoming');
    final upcomingResponse = PopularResponse.fromJson( response);

    upcomingMovies = upcomingResponse.results;
    print(upcomingMovies);
    notifyListeners();
  }

  getOnDisplayMovies() async {
    _onDisplayPage++;
    final response = await _getJsonData('3/movie/now_playing', _onDisplayPage);
    final nowPlayingResponse = NowPlayingResponse.fromJson(response);

    onDisplayMovies = [...onDisplayMovies, ...nowPlayingResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    
    if(moviesCast.containsKey(movieId)) {
      return moviesCast[movieId]!;
    }

    final response = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(response);

    return moviesCast[movieId] ?? creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  Future<ActorResponse> getActor(String actorId) async{
    final response = await _getJsonData('/3/person/$actorId');
    final actorResponse = ActorResponse.fromJson(response);
    print(actorResponse);
    notifyListeners();
    return actorResponse;
  }

  Future<List<Movie>> getMovieByActor(String actorId) async {
    final response = await _getJsonData('/3/person/$actorId/movie_credits');
    final actorResponse = ActorMoviesResponse.fromJson(response);

    return actorResponse.cast;
  }

  void getSuggestionsByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}