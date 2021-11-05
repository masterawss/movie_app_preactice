import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_app/models/details_screen_arguments.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/widgets/movie_poster.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;
  const MovieSlider({
    Key? key,
    required this.movies,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        print('Obtener siguiente página');
        widget.onNextPage();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(this.widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(widget.title!, style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) => MoviePoster(
                movie: widget.movies[index]
              ),
            ),
          )
        ],
      )
    );
  }
}

