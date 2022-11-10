class Verse {
  Verse({
    this.number,
    this.text,
    this.translation,
   
  });

  Number? number;
  TextVerse? text;
  Translation? translation;
  

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        number: Number(inSurah: json["verse_number"],inQuran: json["id"]),     
        text: TextVerse(arab: json['verse'],transliteration: 'Veri Geldii'),
        translation: Translation.fromJson(json["translation"]),
      );
}

class Number {
  Number({
    this.inQuran,
    this.inSurah,
  });

  int? inQuran;
  int? inSurah;
}



class TextVerse {
  TextVerse({
    this.arab,
    this.transliteration,
  });

  String? arab;
  String? transliteration;
}






class Translation {
  Translation({
   
    this.id,
  });
  
  String? id;

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        
        id: json["text"],
      );
}
