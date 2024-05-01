import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../main.dart';
import '../widgets/movie/MovieCastAsRow.dart';
import 'FullMovieListPage.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movie_id;

  const MovieDetailsPage({Key? key, required this.movie_id}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<dynamic> _futureMovieDetails;
  late String _appBarTitle;

  final tmdb = TMDB(
    ApiKeys('2ba52370a157c6797e98e8d28d1239bb', 'apiReadAccessTokenv4'),
  );

  @override
  void initState() {
    super.initState();
    _appBarTitle = "Movie details";
    _futureMovieDetails = fetchMovieDetails();
  }

  Future<dynamic> fetchMovieDetails() async {
    var result =
        tmdb.v3.movies.getDetails(widget.movie_id, appendToResponse: "credits", language: language);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // I don't know how to update the title to movie title
        // The widget just doesn't want to refresh so it's not visually updating
        title: Text(_appBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.play_arrow,
          )),
      body: FutureBuilder(
        future: _futureMovieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            final movie = snapshot.data as Map<String, dynamic>;

            final List<dynamic> genres = movie["genres"];
            String genresString = '';

            for (var genre in genres) {
              genresString += '${genre["name"]}, ';
            }

            genresString = genresString.isNotEmpty
                ? genresString.substring(0, genresString.length - 2)
                : '';

            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                          width: 150,
                          height: 225,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie["title"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${DateFormat("MMMM d, y").format(DateTime.parse(movie["release_date"]))} • ${movie["runtime"]} min",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              genresString,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              movie['overview'],
                              textAlign: TextAlign.left,
                              softWrap: true,
                              overflow:
                                  TextOverflow.clip,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  MovieCastAsRow(cast: movie["credits"]["cast"])
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
