class Surah {
  int? number;
  int? sequence;
  int? numberOfVerses;
  String? name;
  String? namearab;
  String? audiourl;

  Surah(
      {this.number,
      this.sequence,
      this.numberOfVerses,
      this.name,
      this.audiourl,
      this.namearab});

  factory Surah.fromJson(Map<String, dynamic> json) {
    var surah = Surah();
    surah.number = json['id'];
    surah.name = json['name'];
    surah.namearab = json['name_original'];
    surah.sequence = json['surah_id'];
    surah.numberOfVerses = json['verse_count'];
    surah.audiourl = Audio.fromJson(json["audio"]).url;
    return surah;
  }
}

class Audio {
  int? duration;
  String? url;

  Audio({this.duration, this.url});

  factory Audio.fromJson(Map<String, dynamic> json) =>
      Audio(duration: json["duration"], url: json["mp3"]);
}
