import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_app/models/details_screen_arguments.dart';
import 'package:movies_app/models/movie.dart';
class MoviePoster extends StatelessWidget {


  final Movie movie;

  const MoviePoster({
    Key? key,
    required this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroId = 'slider-${Random().nextInt(500)}-${movie.id}';

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: DetailsScreenArguments(movie, heroId)),
            child: Hero(
              tag: heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image:  NetworkImage(movie.fullPosterImg),
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  fit: BoxFit.cover
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}