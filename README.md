# debridify

An app for streaming media from popular debrid services.

## Purpose and problems

I created this app with an idea of replacing [Stremio](https://www.stremio.com/). However I found it hard to scrape torrents without a server and also I couldn't implement a player supporting dolby vision that isn't laggy.

### How would it work (at least in my mind)
1. The user selects an episode/movie.
2. The app scrapes a magnet link (stuck at this step because of the serverless approach).
3. The magnet link is sent to the debrid api (in my case real debrid).
4. The returned direct link to a file (mp4, mkv, etc.) is opened in external player (VLC looks the best for now).

### Todo
- [ ] Trakt integration (lists, progress)
- [ ] Torrent scraping
- [ ] Searching
- [ ] Better landscape views
- [ ] Scraping magnet links and playing them with a debrid service.
- [ ] Selecting which categories (aka. widgets) to show on the home page.
- [ ] Popup asking if you finished the movie/episode after getting back to the app after playing in VLC.


## Screenshots:

### Explore page
![Explore page.png](.github%2Fassets%2FExplore%20page.png)

### Movie details
![Movie details.png](.github%2Fassets%2FMovie%20details.png)

### Show details
![Show details.png](.github%2Fassets%2FShow%20details.png)