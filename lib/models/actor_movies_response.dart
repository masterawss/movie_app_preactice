// To parse this JSON data, do
//
//     final actorMoviesResponse = actorMoviesResponseFromMap(jsonString);

import 'dart:convert';

import 'package:movies_app/models/movie.dart';

class ActorMoviesResponse {
    ActorMoviesResponse({
        required this.cast,
        required this.id,
    });

    List<Movie> cast;
    int id;

    factory ActorMoviesResponse.fromJson(String str) => ActorMoviesResponse.fromMap(json.decode(str));

    factory ActorMoviesResponse.fromMap(Map<String, dynamic> json) => ActorMoviesResponse(
        cast: List<Movie>.from(json["cast"].map((x) => Movie.fromMap(x))),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "cast": List<dynamic>.from(cast.map((x) => x.toMap())),
        "id": id,
    };
}