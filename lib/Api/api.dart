// To parse this JSON data, do
//
//     final movieApi = movieApiFromJson(jsonString);

import 'dart:convert';

List<MovieApi> movieApiFromJson(String str) => List<MovieApi>.from(json.decode(str).map((x) => MovieApi.fromJson(x)));

String movieApiToJson(List<MovieApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MovieApi {
  String title;
  String year;
  String runtime;
  String? poster;

  MovieApi({
    required this.title,
    required this.year,
    required this.runtime,
    this.poster,
  });

  factory MovieApi.fromJson(Map<String, dynamic> json) => MovieApi(
    title: json["Title"],
    year: json["Year"],
    runtime: json["Runtime"],
    poster: json["Poster"],
  );

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Year": year,
    "Runtime": runtime,
    "Poster": poster,
  };
}
