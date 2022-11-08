import 'dart:developer';
import 'dart:io' as ui;
import 'package:universal_io/io.dart' as uio;

import 'package:quran_app/src/profile/formatter/response_formatter.dart';
import 'package:quran_app/src/profile/models/user.dart' as model;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRepository {
  Future<UserResultFormatter> createUser(dynamic body);
  Future<UserResultFormatter> fetchUser(String? email);
  Future<UserResultFormatter> updateUser(int? id, dynamic body);
  Future<UserResultFormatter> deleteUser(int? id);
  Future<UploadResultFormatter> uploadFileImage(
      String fileName, ui.File fileImage);
}

class UserRepositoryImpl implements UserRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<UserResultFormatter> createUser(body) async {
    final res = await supabase.from('Users').insert(body);
    if (res.error != null) {
      return UserResultFormatter(null, res.error?.message);
    }

    Map<String, dynamic> data = res.data[0];
    var user = model.User.fromJson(data);

    return UserResultFormatter(user, null);
  }

  @override
  Future<UserResultFormatter> deleteUser(int? id) async {
    final res = await supabase.from('Users').delete().match(
      {
        'id': id,
      },
    );

    if (res.error != null) {
      return UserResultFormatter(null, res.error?.message);
    }

    return UserResultFormatter(res.data, null);
  }

  @override
  Future<UserResultFormatter> fetchUser(String? email) async {
    final res = await supabase.from('Users').select('*').eq('email', email);
    if (res.error != null) {
      return UserResultFormatter(null, res.error?.message);
    }

    List data = res.data;
    log("User: $data");
    var user = model.User();

    if (data.isEmpty) {
      return UserResultFormatter(null, "Email not registered");
    }

    for (var json in data) {
      user = model.User.fromJson(json);
    }

    return UserResultFormatter(user, null);
  }

  @override
  Future<UserResultFormatter> updateUser(int? id, body) async {
    final res = await supabase.from('Users').update(body).match({'id': id});

    if (res.error != null) {
      return UserResultFormatter(null, res.error?.message);
    }

    var data = res.data;
    log("User: $data");
    var user = model.User();
    for (var json in (data as List)) {
      user = model.User.fromJson(json);
    }

    return UserResultFormatter(user, null);
  }

  @override
  Future<UploadResultFormatter> uploadFileImage(
      String fileName, ui.File fileImage) async {
    uio.File file = uio.File(fileImage.path);

    final res = await supabase.storage.from('assets').upload(
          fileName,
          file,
        );

    if (res.isEmpty) {
      return UploadResultFormatter('Dosya yükleme Hatası', null);
    }

    // final result =
    //     supabase.storage.from('assets').getPublicUrl(res.data.toString());

    final result = await supabase.storage
        .from('assets')
        .createSignedUrl(fileName, 31557600);

    final signedUrl = result;
    log("Signed Bucket Url: $signedUrl");

    if (result.isEmpty) {
      return UploadResultFormatter('SignedURL hatası', null);
    }

    return UploadResultFormatter(null, signedUrl);
  }
}
