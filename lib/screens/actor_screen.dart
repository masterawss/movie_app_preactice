import 'package:flutter/material.dart';
import 'package:movies_app/models/actor_response.dart';
import 'package:movies_app/models/actor_screen_arguments.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/actor_movies_cards.dart';
import 'package:provider/provider.dart';
    
class ActorScreen extends StatelessWidget {

  const ActorScreen({ 
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ActorScreenArguments;


    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    print(args);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actor'),
      ),
      body: ListView(
        children: [
          _cabecera(
            args.nombre,
            args.imagen,
            'actor${args.actorId}'
          ),

          FutureBuilder(
            future: moviesProvider.getActor(args.actorId),
            builder: (_, AsyncSnapshot snapshot) {
              if(!snapshot.hasData){
                return circularLoading();
              }
              final ActorResponse actor = snapshot.data;
              return ActorMoviesCards(actorId: '${actor.id}');
            }
          ),
        ],
      ),
    );
  }

  Widget circularLoading(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _cabecera( String nombre, String imagen, String heroId) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          Container(
            width: 190,
            child: Hero(
              tag: heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: const AssetImage('no-image.jpg'),
                  image: NetworkImage(imagen),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              nombre, 
              style: const TextStyle(
                fontSize: 20
              ),
            ),
          ),
        ],
      )
    );
  }
}