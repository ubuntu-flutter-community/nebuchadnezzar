import 'package:html/parser.dart';

extension StringX on String {
  ({String? songName, String? artist}) get splitByDash {
    String? songName;
    String? artist;
    var split = this.split(' - ');
    if (split.isNotEmpty) {
      artist = split.elementAtOrNull(0);
      songName = split.elementAtOrNull(1);
      if (split.length == 3 && songName != null) {
        songName = songName + (split.elementAtOrNull(2) ?? '');
      }
    } else {
      split = this.split('-');
      if (split.isNotEmpty) {
        artist = split.elementAtOrNull(0);
        songName = split.elementAtOrNull(1);
        if (split.length == 3 && songName != null) {
          songName = songName + (split.elementAtOrNull(2) ?? '');
        }
      }
    }
    return (songName: songName, artist: artist);
  }

  String? get unEscapeHtml => HtmlParser(this).parseFragment().text ?? this;
}
