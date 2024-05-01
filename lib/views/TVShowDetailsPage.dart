import 'package:debridify/widgets/tv/SeasonEpisodesAsList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../main.dart';
import '../widgets/movie/MovieCastAsRow.dart';
import 'FullMovieListPage.dart';

class TVShowDetailsPage extends StatefulWidget {
  final int show_id;

  const TVShowDetailsPage({Key? key, required this.show_id}) : super(key: key);

  @override
  _TVShowDetailsPageState createState() => _TVShowDetailsPageState();
}

class _TVShowDetailsPageState extends State<TVShowDetailsPage> {
  late Future<dynamic> _futureShowDetails;
  late String _appBarTitle;
  late int selectedSeason;

  final tmdb = TMDB(
    ApiKeys('2ba52370a157c6797e98e8d28d1239bb', 'apiReadAccessTokenv4'),
  );

  @override
  void initState() {
    super.initState();
    _appBarTitle = "Show details";
    _futureShowDetails = fetchShowDetails();
    selectedSeason = 1;
  }

  void updateSelectedSeason(int index) {
    setState(() {
      selectedSeason = index;
    });
  }

  Future<dynamic> fetchShowDetails() async {
    var result =
    tmdb.v3.tv.getDetails(widget.show_id, appendToResponse: "credits", language: language);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: FutureBuilder(
        future: _futureShowDetails,
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
            final show = snapshot.data as Map<String, dynamic>;

            final List<dynamic> genres = show["genres"];
            String genresString = '';

            for (var genre in genres) {
              genresString += '${genre["name"]}, ';
            }

            genresString = genresString.isNotEmpty
                ? genresString.substring(0, genresString.length - 2)
                : '';

            return SingleChildScrollView(
              child: Padding(
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
                            'https://image.tmdb.org/t/p/w500${show['poster_path']}',
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
                                show["name"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${DateFormat("MMMM d, y").format(DateTime.parse(show["first_air_date"]))} • ${show["status"]}",
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
                              SizedBox(
                                height: 145,
                                child: Text(
                                  show['overview'],
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  // Clip overflowing text
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 50, // Set a fixed height here
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: show["seasons"].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: GestureDetector(
                              child: Chip(
                                label: Text(show["seasons"][index]["name"]),
                                backgroundColor: selectedSeason == show["seasons"][index]["season_number"]
                                    ? Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    : Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                updateSelectedSeason(show["seasons"][index]["season_number"]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    SeasonEpisodesAsList(
                      show_id: widget.show_id,
                      season: selectedSeason,
                      onSeasonSelected: updateSelectedSeason,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                      child: Text(
                        "Cast",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MovieCastAsRow(cast: show["credits"]["cast"]),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
