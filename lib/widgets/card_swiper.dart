import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:movies_app/models/details_screen_arguments.dart';
import 'package:movies_app/models/movie.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;

  const CardSwiper({
    Key? key,
    required this.movies
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if(movies.isEmpty){
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator()
        )
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child:  Text('Próximos estrenos', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: double.infinity,
          height: size.height * 0.55,
          child: Swiper(
            itemCount: movies.length,
            scale: 0.9,
            viewportFraction: 0.7,
            itemBuilder: ( _ , int index) {
              final movie = movies[index];
              final heroId = 'swiper${movie.id}';
              final _fechaLanzamiento = Jiffy(movie.releaseDate).fromNow();
              return FutureBuilder(
                future: Jiffy.locale("es"),
                builder: (_, __) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'details', arguments: DetailsScreenArguments(movie, heroId)),
                    child: Column(
                      children: [
                        Hero(
                          tag: heroId,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: FadeInImage(
                              image: NetworkImage(movie.fullPosterImg),
                              placeholder: const AssetImage('assets/no-image.jpg'),
                              fit: BoxFit.cover
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.blueGrey[800],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(_fechaLanzamiento)
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}