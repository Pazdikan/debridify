import 'package:debridify/main.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class FullMovieListPage extends StatelessWidget {
  final tmdb = TMDB(
    ApiKeys('2ba52370a157c6797e98e8d28d1239bb', 'apiReadAccessTokenv4'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Movies'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<dynamic>(
          future: tmdb.v3.movies.getDetails(671, appendToResponse: "credits", language: language),
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
              final movies = snapshot.data['results'] as List<dynamic>;
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return ListTile(
                    title: Text(movie['title']),
                    subtitle: Text(movie['overview']),
                    onTap: () {
                      // Handle movie tap
                      print('Clicked on ${movie['title']}');
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}