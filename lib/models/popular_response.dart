// To parse this JSON data, do
//
//     final popularResponse = popularResponseFromMap(jsonString);

import 'dart:convert';

import 'package:movies_app/models/movie.dart';

class PopularResponse {
    PopularResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalMovies,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalMovies;

    factory PopularResponse.fromJson(String str) => PopularResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PopularResponse.fromMap(Map<String, dynamic> json) => PopularResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalMovies: json["total_results"],
    );

    Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalMovies,
    };
}
