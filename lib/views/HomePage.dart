import 'package:debridify/views/MovieDetailsPage.dart';
import 'package:debridify/views/TVShowDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../main.dart';
import '../widgets/movie/MovieCastAsRow.dart';
import 'FullMovieListPage.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tmdb = TMDB(
    ApiKeys('2ba52370a157c6797e98e8d28d1239bb', 'apiReadAccessTokenv4'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Trending movies",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 250, // Adjust height as needed
              child: FutureBuilder<dynamic>(
                future: tmdb.v3.trending.getTrending(mediaType: MediaType.movie, timeWindow: TimeWindow.week, language: language),
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
                    final movies =
                    snapshot.data['results'] as List<dynamic>;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsPage(movie_id: movie["id"]),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                    width: 150, // Adjust width as needed
                                    height: 225, // Adjust height as needed
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _trimTitle(movie['title']),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 16),
              child: Text(
                "Trending shows",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 250, // Adjust height as needed
              child: FutureBuilder<dynamic>(
                future: tmdb.v3.trending.getTrending(mediaType: MediaType.tv, timeWindow: TimeWindow.week, language: language),
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
                    final movies =
                    snapshot.data['results'] as List<dynamic>;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final show = movies[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TVShowDetailsPage(show_id: show["id"]),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${show['poster_path']}',
                                    width: 150, // Adjust width as needed
                                    height: 225, // Adjust height as needed
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _trimTitle(show['name']),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _trimTitle(String title) {
    if (title.length > 23) {
      return title.substring(0, 20) + "...";
    }
    return title;
  }
}