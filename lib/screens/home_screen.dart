import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate())
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            CardSwiper(movies: moviesProvider.upcomingMovies),
            MovieSlider(
              movies: moviesProvider.onDisplayMovies,
              title: 'En cines',
              onNextPage: () => moviesProvider.getOnDisplayMovies(),
            ),
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
            // MovieSlider(),
            // MovieSlider(),
            // MovieSlider(),
            // MovieSlider(),
            // MovieSlider(),
          ]
        ),
      )
    );
  }
}