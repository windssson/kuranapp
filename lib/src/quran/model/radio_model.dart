class Radioitem {
  int? id;
  String? url;
  String? radioadi;
  String? radioaciklama;

  Radioitem({this.id, this.url, this.radioadi, this.radioaciklama});
  factory Radioitem.fromJson(Map<String, dynamic> json) {
    var gelen = Radioitem();
    gelen.id = json["radio_id"];
    gelen.url = json["radio_url"];
    gelen.radioadi = json["radio_adi"];
    gelen.radioaciklama = json["radio_aciklama"];

    return gelen;
  }
}
