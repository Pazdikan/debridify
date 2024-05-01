import 'package:flutter/material.dart';

class MovieCastAsRow extends StatelessWidget {
  final List<dynamic> cast;

  const MovieCastAsRow({Key? key, required this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> castList = cast.cast<Map<String, dynamic>>();

    return SizedBox(
      height: 200, // Set a fixed height here
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: castList.length > 15 ? 15 : castList.length,
        itemBuilder: (context, index) {
          return Padding(padding: EdgeInsets.fromLTRB(0,0,16,0), child: _buildCastCard(castList[index], context),);
        },
      ),
    );

  }

  Widget _buildCastCard(Map<String, dynamic> actor, context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          actor['profile_path'] != null ?
          Image.network(
            'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
            width: 150,
            height: 200,
            fit: BoxFit.cover,
          ) : Image.network(
    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
      width: 150,
      height: 200,
      fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    actor['name'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    actor['character'],
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
