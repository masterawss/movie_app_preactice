import 'package:flutter/material.dart';
import 'package:movies_app/models/details_screen_arguments.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return getResults(context);
  }

  Widget _emptyContainer (){
    return const Center(
      child: Icon(
        Icons.movie,
        color: Colors.white54,
        size: 130,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return getResults(context);
  }

  
  Widget getResults(BuildContext context) {
    if(query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);
    
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
        if(!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index])
        );
      },

    );
  }

}

class _MovieItem extends StatelessWidget {
    
    final Movie movie;

    const _MovieItem({
      Key? key, 
      required this.movie
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      final heroId = 'search${movie.id}';
      return ListTile(
        leading: Hero(
          tag: heroId,
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width:60,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: (){
          Navigator.pushNamed(context, 'details', arguments: DetailsScreenArguments(movie, heroId));
        }
      );
    }
  }
