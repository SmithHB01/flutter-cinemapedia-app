// Flutter
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Project
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class MovieMasonry extends StatefulWidget {
  final bool isLastPage;
  final List<Movie> movies;
  final ScrollController scrollController;
  final Future<void> Function()? loadNextPage;

  const MovieMasonry({
    required this.movies,
    required this.scrollController,
    this.loadNextPage,
    this.isLastPage = false,
    super.key,
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  bool _showGoUpButton = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() async {
      final maxScrollHeight = widget.scrollController.position.maxScrollExtent;
      final currentPosition = widget.scrollController.position.pixels;

      if (widget.scrollController.position.pixels - 100 > 0) {
        _showGoUpButton = true;
        setState(() {});
      } else {
        _showGoUpButton = false;
        setState(() {});
      }

      if (currentPosition + 50 >= maxScrollHeight) {
        if (widget.loadNextPage case final loadNextPage?) {
          await loadNextPage();
          // We await 1 second, so we are sure the user isn't scrolling anymore
          await Future.delayed(const Duration(seconds: 1));
          if (widget.isLastPage) return;

          widget.scrollController.animateTo(
            currentPosition + 200,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MasonryGridView.count(
            controller: widget.scrollController,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];

              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: MoviePosterLink(movie: movie),
                );
              }

              return MoviePosterLink(movie: movie);
            },
          ),
        ),

        FadeIn(
          animate: _showGoUpButton,
          child: Container(
            margin: const EdgeInsets.only(right: 27, bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipOval(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), padding: const EdgeInsets.all(16)
                  ),
                  // heroTag: ['CustomTag'],
                  onPressed: () => widget.scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                  ),
                  child: Icon(Icons.arrow_upward_rounded, color: colors.primary,),
                ),
              ),
            ),
          ),
        ),
        
        // FadeIn(
        //   animate: _showGoUpButton,
        //   child: Container(
        //     margin: const EdgeInsets.only(right: 30, bottom: 10),
        //     child: Align(
        //       alignment: Alignment.bottomRight,
        //       child: ClipOval(
        //         child: FloatingActionButton(
        //           // heroTag: ['CustomTag'],
        //           onPressed: () => widget.scrollController.animateTo(
        //             0,
        //             duration: const Duration(milliseconds: 700),
        //             curve: Curves.easeInOut,
        //           ),
        //           child: const Icon(Icons.arrow_upward_rounded),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        
        
      ],
    );
  }
}
