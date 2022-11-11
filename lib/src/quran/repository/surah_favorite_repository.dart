import 'dart:developer';

import 'package:quran_app/src/quran/formatter/surah_favorite_formatter.dart';
import 'package:quran_app/src/quran/model/surah_favorite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SurahFavoriteRepository {
  Future<SurahFavoriteFormatter> getListOfFavoriteSurah(int userID);
  Future<SurahFavoriteFormatter> addSurahFavorite(int userID, int surahID);
  Future<SurahFavoriteFormatter> removeSurahFavorite(int userID, int surahID);
  Future<SurahFavoriteFormatter> removeAllSurahFavorite(int userID);
}

class SurahFavoriteRepositoryImpl implements SurahFavoriteRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<SurahFavoriteFormatter> getListOfFavoriteSurah(int userID) async {
    final res = await supabase
        .from('SurahFavorites')
        .select('*')
        .eq('user_id', userID)
        .order('surah_id', ascending: true)
        .onError((error, stackTrace) {
      return SurahFavoriteFormatter(error.toString(), null);
    });
    log(res.toString());
    List data = res;
    log("Surah Favorites: $data");
    List<SurahFavorite> surahFavorites = [];

    if (data.isNotEmpty) {
      for (var json in data) {
        var surahFavorite = SurahFavorite.fromJson(json);
        surahFavorites.add(surahFavorite);
      }
    }

    return SurahFavoriteFormatter(null, surahFavorites);
  }

  @override
  Future<SurahFavoriteFormatter> addSurahFavorite(
      int userID, int surahID) async {
    final res = await supabase.from('SurahFavorites').insert({
      'user_id': userID,
      'surah_id': surahID,
    }).select();
    log(res.toString());
    SurahFavorite data = SurahFavorite.fromJson(res[0]);

    return SurahFavoriteFormatter(null, [data]);
  }

  @override
  Future<SurahFavoriteFormatter> removeSurahFavorite(
      int userID, int surahID) async {
    final res = await supabase.from('SurahFavorites').delete().match(
      {
        'user_id': userID,
        'surah_id': surahID,
      },
    ).select().onError(
        (error, stackTrace) => SurahFavoriteFormatter(error.toString(), null));

    SurahFavorite data = SurahFavorite.fromJson(res[0]);

    return SurahFavoriteFormatter(null, [data]);
  }

  @override
  Future<SurahFavoriteFormatter> removeAllSurahFavorite(int userID) async {
    final res = await supabase.from('SurahFavorites').delete().match(
      {
        'user_id': userID,
      },
    ).select().onError(
        (error, stackTrace) => SurahFavoriteFormatter(error.toString(), null));

    List data = res;
    List<SurahFavorite> surahFavorites = [];

    if (data.isNotEmpty) {
      for (var json in data) {
        var surahFavorite = SurahFavorite.fromJson(json);
        surahFavorites.add(surahFavorite);
      }
    }

    return SurahFavoriteFormatter(null, surahFavorites);
  }
}
