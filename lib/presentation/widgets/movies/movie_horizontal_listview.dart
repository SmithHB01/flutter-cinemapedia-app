// Flutter
import 'package:flutter/material.dart';

// Third Party
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

// Project
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

class MovieHorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;

  final VoidCallback? loadNextPage;

  const MovieHorizontalListView({
    required this.movies,
    super.key,
    this.title,
    this.subTitle,
    this.loadNextPage,
  });

  @override
  State<MovieHorizontalListView> createState() =>
      _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {
  final scrollController = ScrollController();

 
  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() {
      if ( widget.loadNextPage == null ) return;

      if ( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent ) {
        widget.loadNextPage!();
      }

    });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, idx) {
                return FadeInRight(child: _Slide(movie: widget.movies[idx]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => context.push('/movie/${movie.id}'),
      child: Container(
        margin:
            const EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: 150,
                  height: 220,
                  image: NetworkImage(movie.posterPath),
                  placeholder:
                      const AssetImage('assets/loaders/bottle-loader.gif'),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 150,
              child: Text(
                movie.title,
                maxLines: 2,
                style: textStyles.titleSmall,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  Text(
                    '${movie.voteAverage}',
                    style: textStyles.bodyMedium!
                        .copyWith(color: Colors.yellow.shade800),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                  const Spacer(),
                  Text(
                    HumanFormats.number(movie.popularity),
                    style: textStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
