import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quran_app/src/profile/formatter/response_formatter.dart';
import 'package:quran_app/src/profile/models/user.dart' as model;
import 'package:quran_app/src/profile/repositories/user_repository.dart';
import 'package:quran_app/src/profile/views/signin_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quran_app/src/quran/view/surah_page.dart';

abstract class AuthController extends GetxController {
  Future<UserResultFormatter> signUp(
    String email,
    String password, {
    String? name,
    String? photoUrl,
    String? avatarUrl,
  });
  Future<UserResultFormatter> signInWithGoogle();
  Future<Session?> recoverSession(String session);
  Future<UserResultFormatter> signIn(String email, {String? password});
  Future<bool> signOut();
}

class AuthControllerImpl extends AuthController {
  final _supabase = Supabase.instance.client;
  final _userRepo = UserRepositoryImpl();

  // signIn with google
  // get user info like email and name
  // signUp to supabase
  // await supabase.auth.signUp(email, password)
  // save user to db supabase
  @override
  Future<UserResultFormatter> signInWithGoogle() async {
    try {
      var user = model.User();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return UserResultFormatter(null, "Google ile giriş başarısız..");
      } else {
        user.email = googleUser.email;
        user.name = googleUser.displayName;
        user.photoUrl = googleUser.photoUrl;
      }

      return UserResultFormatter(user, null);
    } on PlatformException catch (e) {
      return UserResultFormatter(
          null, 'Error - Google ile giriş başarısız.. $e');
    }
  }

  @override
  Future<UserResultFormatter> signUp(String email, String password,
      {String? name, String? photoUrl, String? avatarUrl}) async {
    try {
      final box = Get.find<GetStorage>();

      final AuthResponse res =
          await _supabase.auth.signUp(email: email, password: password);

      if (res.session == null) {
        log("Supabase Giriş Hatası");
        return UserResultFormatter(null, 'Supabase giriş hatası');
      }
      box.write('user', res.session!.persistSessionString);

      log('*************************************');
      log(res.user!.id);
      log(password);
      log(email);
      log('*********************************');

      final result = await _userRepo.createUser({
        "uuid": res.user!.id,
        "name": name,
        "email": email,
        "photo_url": photoUrl,
        "avatar_url": avatarUrl,
        "pass": password
      });

      log("Sign up is successful for user");
      return result;
    } catch (e) {
      log("Sign up error: Autsayfasi $e");
      return UserResultFormatter(null, e.toString());
    }
  }

  @override
  Future<Session?> recoverSession(String session) async {
    final res = await _supabase.auth.recoverSession(session);
    if (res.session == null) {
      log("Recovery session hatası");
      return null;
    }

    // ignore: todo
    // TODO: handle this finishing result
    return res.session;
  }

  authStateNow() {
    _supabase.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        Get.offAll(SurahPage());
      } else if (event.event == AuthChangeEvent.signedOut) {
        Get.offAll(SignInPage());
      }
    });
  }

  @override
  Future<UserResultFormatter> signIn(String email, {String? password}) async {
    try {
      final res = await _supabase.auth
          .signInWithPassword(email: email, password: password!);
      log('Buradayımm');
      if (res.session == null) {
        log("Supabase giriş hatası");
        return UserResultFormatter(null, 'Supabase giriş hatası');
      }

      var loggedInUser = res.user;
      var user = model.User();
      user.email = loggedInUser!.email;
      user.uid = loggedInUser.id;

      final box = Get.put(GetStorage());

      log(res.session!.persistSessionString);
      box.write('user', res.session!.persistSessionString);

      log("Sign in is successful for user ID: giris yapan");
      return UserResultFormatter(user, null);
    } catch (e) {
      log("Sign in error:asd $e");
      return UserResultFormatter(null, e.toString());
    }
  }


  @override
  Future<bool> signOut() async {
    await _supabase.auth.signOut().onError((error, stackTrace) => false);

    final box = Get.find<GetStorage>();

    await box.remove('user');
    await box.erase();
    final session = box.read('user');
    log("Session : $session");

    log('Successfully logged out; clearing session string');
    return true;
  }
}
