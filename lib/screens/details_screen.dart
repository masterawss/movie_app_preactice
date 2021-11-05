import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:movies_app/models/details_screen_arguments.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsScreenArguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(
            title: args.movie.title,
            image: args.movie.fullBackdropImg,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(
                movie: args.movie,
                heroId: args.heroId,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _Overview(
                  overview: args.movie.overview,
                ),
              ),
              CastingCards(
                movieId: args.movie.id,
              )
            ]),
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String title;
  final String image;

  const _CustomAppBar({
    Key? key,
    required this.title,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.zero,
        title: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 15),
          width: double.infinity,
          color: Colors.black12,
          child: Text(
            title
          )
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(image),
          fit: BoxFit.cover
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  final String heroId;
  const _PosterAndTitle({
    Key? key,
    required this.movie,
    required this.heroId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top:20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(movie.fullPosterImg),
                placeholder: const AssetImage('assets/no-image.jpg'),
                height: 200,
                fit: BoxFit.cover
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 210),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline5,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    movie.originalTitle,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.subtitle1
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star),
                    const SizedBox(width:5),
                    Text('${movie.voteAverage}', style: Theme.of(context).textTheme.caption,)
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: Jiffy.locale("es"),
                  builder: (_, __) {
                    final _fechaLanzamiento = Jiffy(movie.releaseDate).yMMMMd;

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[900]
                      ),
                      child: Text(_fechaLanzamiento),
                    );
                  }
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String overview;
  const _Overview({
    Key? key,
    required this.overview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            overview,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1
          ),
        ),
      ],
    );
  }
}