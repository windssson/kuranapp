class Surah {
  int? number;
  int? sequence;
  int? numberOfVerses;
  String? name;
  String? namearab;

  Surah({
    this.number,
    this.sequence,
    this.numberOfVerses,
    this.name,
    this.namearab
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var surah = Surah();
    surah.number = json['id'];
    surah.name = json['name'];
    surah.namearab=json['name_original'];
    surah.sequence = json['surah_id'];
    surah.numberOfVerses = json['verse_count'];
    return surah;
  }
}
