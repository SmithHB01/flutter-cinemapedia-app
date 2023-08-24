import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';




class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();


    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId );
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId );
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider)[ widget.movieId ];

    if ( movie == null){
      return const Scaffold(body: Center( child: CircularProgressIndicator( strokeWidth: 2)));
    }


    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1
          ))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: size.width * 0.3,
              ),
            ),

            const SizedBox( width: 10),

            // Descripcions
            SizedBox(
              width: (size.width - 40) * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleLarge,),
                  Text(movie.overview),
                ],
              ),
            )

          ],
        ),
        ),

        // Generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                ),
              ))
            ],
          ),
        ),

        _ActorByMovie(movieId: movie.id.toString(),),

        const SizedBox(height: 50),
      ],
    );
  }
}


class _ActorByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorByMovieProvider);

    if ( actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator( strokeWidth: 2);
    }


    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return  Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Actor Photo
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Nombre
                const SizedBox( height: 5),

                Text(actor.name, maxLines: 2),
                Text(actor.character ?? '',
                  maxLines: 2,
                  style: const TextStyle( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                ),

              ],
            ),
          );
          
        },
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch( localStoreRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId); // si esta en favoritos
});

class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({
    required this.movie
  });

  @override
  Widget build(BuildContext context, ref ) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: const Color.fromARGB(135, 28, 29, 114),
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {

            // ref.read( localStoreRepositoryProvider)
            // .toggleFavorite(movie);

            await ref.read(favoriteMoviesProvider.notifier)
              .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
            
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
            ? const Icon (Icons.favorite_rounded, color: Colors.red)
            : const Icon (Icons.favorite_border_rounded),
            error: (_, __) => throw UnimplementedError(),
            loading: () => const CircularProgressIndicator( strokeAlign: 2),
          ),


          // const Icon (Icons.favorite_border_rounded)
          // icon: const Icon (Icons.favorite_rounded, color: Colors.red),
        ),



      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 5),
        // titulos de peliculas
        // title: Text( 
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if ( loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                  
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.2, 0.4],
              colors: [
                Color.fromARGB(24, 243, 49, 250),
                Colors.transparent, 
              ]
            ),

            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [
                Colors.transparent,
                Color.fromARGB(24, 243, 49, 250)
              ]
            ),

            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.2],
              colors: [
                Color.fromARGB(24, 243, 49, 250),
                Colors.transparent,
              ]
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;



  const _CustomGradient({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.stops, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            stops: stops,
            colors: colors
          )
        ) 
      ),
    );
  }
}


