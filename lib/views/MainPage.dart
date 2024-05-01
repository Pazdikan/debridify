import 'package:debridify/views/ExplorePage.dart';
import 'package:debridify/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'FullMovieListPage.dart';
import 'Player.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        HomePage(title: "Debridify"),

        ExplorePage(title: "Debridify"),

        Center(
          child: ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse("vlc://23.download.real-debrid.com/d/TEXULHJDETSSO/Barbie%202023%20AMZN%204K%20WEBRip%202160p%20DD%2B5.1%20Atmos%20DoVi%20HDR%20H.265-MgB.mkv"));
            }, child: Text("Open VLC"),
          ),
        )
      ][currentPageIndex],
    );
  }

  Future<void> _launchVLC(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}