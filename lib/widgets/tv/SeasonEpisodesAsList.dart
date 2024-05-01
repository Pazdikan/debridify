import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../main.dart';

extension IterableIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    var index = 0;
    for (final e in this) {
      yield f(index++, e);
    }
  }
}

class SeasonEpisodesAsList extends StatefulWidget {
  final int show_id;
  final int season;
  final Function(int) onSeasonSelected; // Callback function

  const SeasonEpisodesAsList({
    Key? key,
    required this.show_id,
    required this.season,
    required this.onSeasonSelected, // Accept the callback function
  }) : super(key: key);

  @override
  State<SeasonEpisodesAsList> createState() => _SeasonEpisodesAsListState();
}

class _SeasonEpisodesAsListState extends State<SeasonEpisodesAsList> {
  late Future<dynamic> _futureSeasonDetails;

  final tmdb = TMDB(
    ApiKeys('2ba52370a157c6797e98e8d28d1239bb', 'apiReadAccessTokenv4'),
  );

  @override
  void initState() {
    super.initState();
    _futureSeasonDetails = fetchSeasonDetails();
  }

  @override
  void didUpdateWidget(SeasonEpisodesAsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.season != oldWidget.season) {
      _futureSeasonDetails = fetchSeasonDetails();
    }
  }

  Future<dynamic> fetchSeasonDetails() async {
    var result = tmdb.v3.tvSeasons.getDetails(widget.show_id, widget.season, language: language);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureSeasonDetails,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error fetching data'),
          );
        } else {
          final season = snapshot.data as Map<String, dynamic>;
          final episodes = season["episodes"] as List<dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: episodes.mapIndexed<Widget>((index, episode) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: _buildEpisodeCard(episode, index, episodes.length),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildEpisodeCard(Map<String, dynamic> episode, int index, int all) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    episode['still_path'] != null
                        ? 'https://image.tmdb.org/t/p/w500${episode['still_path']}'
                        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                    width: 150,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30, // Adjust the size of the icon as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
            Expanded( // Added Expanded widget here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${episode['season_number']}x${episode['episode_number']} ${episode['name']}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${episode["runtime"]} min",
                    style: TextStyle(fontSize: 14.0, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          episode['overview'],
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        if (index != all - 1) Divider(),
      ],
    );
  }
}
