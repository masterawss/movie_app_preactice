// To parse this JSON data, do
//
//     final actorResponse = actorResponseFromMap(jsonString);

import 'dart:convert';

class ActorResponse {
    ActorResponse({
        this.birthday,
        required this.knownForDepartment,
        required this.deathday,
        required this.id,
        required this.name,
        required this.alsoKnownAs,
        required this.gender,
        required this.biography,
        required this.popularity,
        this.placeOfBirth,
        this.profilePath,
        required this.adult,
        this.imdbId,
        required this.homepage,
    });

    String? birthday;
    String knownForDepartment;
    dynamic deathday;
    int id;
    String name;
    List<String> alsoKnownAs;
    int gender;
    String biography;
    double popularity;
    String? placeOfBirth;
    String? profilePath;
    bool adult;
    String? imdbId;
    dynamic homepage;

    get profileImage {
      if(profilePath != null)
        return 'https://image.tmdb.org/t/p/w500${profilePath}';
      return 'https://www.unheval.edu.pe/veterinaria/wp-content/uploads/2021/07/empty-1.jpg';
    }

    factory ActorResponse.fromJson(String str) => ActorResponse.fromMap(json.decode(str));

    factory ActorResponse.fromMap(Map<String, dynamic> json) => ActorResponse(
        birthday: json["birthday"] ?? null,
        knownForDepartment: json["known_for_department"],
        deathday: json["deathday"],
        id: json["id"],
        name: json["name"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        gender: json["gender"],
        biography: json["biography"],
        popularity: json["popularity"].toDouble(),
        placeOfBirth: json["place_of_birth"] ?? null,
        profilePath: json["profile_path"] ?? null,
        adult: json["adult"],
        imdbId: json["imdb_id"] ?? null,
        homepage: json["homepage"],
    );
}
