import 'package:flutter/material.dart';


class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  

  Stream<String> getLoadingMessages(){
    final messsages = <String>[
      'Cargando peliculas 🧸',
      'Comprando palomitas de maiz 🍿',
      'Cargando populares 🔝',
      'Llamando a mi novia 🥰',
      'Ya casi esta 🤭',
      'Esto esta tardando mas de lo esperado 😥',

    ];
    return Stream.periodic( const Duration(milliseconds: 1200), (Step){
      return messsages[Step];
    }).take(messsages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor 🤑'),
          const SizedBox( height: 10),
          const CircularProgressIndicator(),
          const SizedBox( height: 10),

          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if ( !snapshot.hasData) return const Text('Cargando...');

              return Text(snapshot.data!);
              
            },
          ),

        ],
      ),
    );
  }
}