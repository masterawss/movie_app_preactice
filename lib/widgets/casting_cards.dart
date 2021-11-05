import 'package:flutter/material.dart';
import 'package:movies_app/models/actor_screen_arguments.dart';
import 'package:movies_app/models/credits_response.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class CastingCards extends StatelessWidget {

  final int movieId;

  const CastingCards({
    Key? key,
    required this.movieId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (context, AsyncSnapshot<List<Cast>> snapshot) {

        if(!snapshot.hasData){
          return SkeletonGridLoader(
            items: 4,
            itemsPerRow: 4,
            direction: SkeletonDirection.ltr,
            highlightColor: Colors.grey.shade100,
            builder: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: 140,
                height: 200,
                color: Colors.white30,
              ),
            ),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Actores', style: TextStyle(
                fontSize: 20
              )),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                height: 180,
                child: ListView.builder(
                  itemCount: cast.length,
                  itemBuilder: (_, int index) => _CastCard(actor: cast[index]),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        );

      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;
  const _CastCard({Key? key, required this.actor}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 100,
      margin: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context, 'actor', 
          arguments: ActorScreenArguments(
            actorId: '${actor.id}',
            imagen: actor.fullProfileImg,
            nombre: actor.name
          )),
        child: Column(
          children: [
            Hero(
              tag: 'actor${actor.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(actor.fullProfileImg),
                  fit: BoxFit.cover,
                  height: 140,
                  width: 100,
                ),
              ),
            ),
            Text(
              actor.name,
              overflow: TextOverflow.fade,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}