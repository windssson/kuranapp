import 'package:quran_app/src/quran/model/radio_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Radioislemler {
  Future<List<Radioitem>> getListRadio() async {
    var db = Supabase.instance.client;
    List<Radioitem> listem = [];
    var gelen = await db.from('radiolist').select('*').then((value) {
      return value;
    });
    List veri = gelen;
    for (var json in veri) {
      listem.add(Radioitem.fromJson(json));
    }
    return listem;
  }
}
