import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({ super.key});

  @override
HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();

    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
    ref.read( topratedMoviesProvider.notifier ).loadNextPage();
  }


  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final slideShowMovies = ref.watch( moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider);
    final popularMovies = ref.watch( popularMoviesProvider);
    final upcomingMovies = ref.watch( upcomingMoviesProvider);
    final topratedMovies = ref.watch( topratedMoviesProvider);
    

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            // titlePadding: EdgeInsets.all(0),
            title: CustomAppbar(),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {

              return Column(
                  children: [
              
                    // const CustomAppbar(),
              
                    MoviesSlideshow(movies: slideShowMovies),
              
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En Cines',
                      subTitle: 'Lunes 20',
                      loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
                      
                    ),
              
              
                    MovieHorizontalListview(
                      movies: upcomingMovies,
                      title: 'Proximamente',
                      subTitle: 'Esta semana',
                      loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage()
                      
                    ),
              
                    MovieHorizontalListview(
                      movies: popularMovies,
                      title: 'Populares',
                      subTitle: 'Este mes',
                      loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage()
                      
                    ),
              
                    MovieHorizontalListview(
                      movies: topratedMovies,
                      title: 'Mejor calificadas',
                      subTitle: 'Todos los tiempos',
                      loadNextPage: () => ref.read(topratedMoviesProvider.notifier).loadNextPage()
                      
                    ),
              
              
                    const SizedBox( height: 10)
              
              
                  ]
              );
            
            },
            childCount: 1
          )
        ),

      ],
    );
  }
}