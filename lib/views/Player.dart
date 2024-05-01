import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DebridifyPlayer extends StatefulWidget {
  const DebridifyPlayer({Key? key}) : super(key: key);

  @override
  State<DebridifyPlayer> createState() => DebridifyPlayerState();
}

class DebridifyPlayerState extends State<DebridifyPlayer> {
  // Create a [Player] to control playback.
  late final player = Player();

  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(
        'https://23.download.real-debrid.com/d/TEXULHJDETSSO/Barbie%202023%20AMZN%204K%20WEBRip%202160p%20DD%2B5.1%20Atmos%20DoVi%20HDR%20H.265-MgB.mkv'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
        child: Video(
          controller: controller,
          subtitleViewConfiguration: const SubtitleViewConfiguration(
            style: TextStyle(
              height: 1.4,
              fontSize: 48.0,
              letterSpacing: 0.0,
              wordSpacing: 0.0,
              color: Color(0xffffffff),
              fontWeight: FontWeight.normal,
              backgroundColor: Color(0xaa000000),
            ),
            textAlign: TextAlign.center,
            padding: EdgeInsets.all(24.0),
          ),
        ),
      ),
    );
  }
}
