import 'package:debridify/views/MoviesTabExplorePage.dart';
import 'package:debridify/views/TVShowTabExplorePage.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../main.dart';
import 'FullMovieListPage.dart';

class ExplorePage extends StatefulWidget {
  final String title;

  const ExplorePage({Key? key, required this.title}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: 'Movies'),
    Tab(text: 'TV Shows'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: [
            MoviesTabExplorePage(title: "Explore movies"),
            TVShowTabExplorePage(title: "Explore TV")
          ],
        ),
      ),
    );
  }
}