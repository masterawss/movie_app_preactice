import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/movie_poster.dart';
import 'package:provider/provider.dart';
    
class ActorMoviesCards extends StatelessWidget {

  final String actorId;
  const ActorMoviesCards({ 
    Key? key,
    required this.actorId
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
          future: moviesProvider.getMovieByActor(actorId),
          builder: (_, AsyncSnapshot<List<Movie>> snapshot){

            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final movies = snapshot.data!;

            return GridView.count(
                crossAxisCount: 3,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                childAspectRatio: 4/8,
                children: List.generate(movies.length, (index) => MoviePoster(movie: movies[index])),
              );

            // return Container();
            // return ListView.builder(
            //   itemCount: movies!.length,
            //   itemBuilder: (_, int index) => MoviePoster(movie: movies[index]),
            // );

            // Hero(
            //   tag: actor.id,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: FadeInImage(
            //       placeholder: const AssetImage('assets/no-image.jpg'), 
            //       image: NetworkImage(actor.fullProfileImg),
            //       fit: BoxFit.cover,
            //       height: 140,
            //       width: 100,
            //     ),
            //   ),
            // ),
          }
        );
  }

}