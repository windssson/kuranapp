import 'package:get/get.dart';

class GlobalState extends GetxController {
  var isLoading = false.obs;
  var isLoadingGoogle = false.obs;
  var isSubmitted = false.obs;
  var isObscure = true.obs;
  var isOpen = false.obs;

  var emailError = "".obs;
  var passwordError = "".obs;
  var emailText = "".obs;
  var passwordText = "".obs;

  String? validateEmail() {
    final text = emailText.value;
    if (text.isEmpty) {
      emailError("Email alanı boş olamaz");
      return emailError.value;
    }

    if (!GetUtils.isEmail(text)) {
      emailError("Email kayıtlı değil");
      return emailError.value;
    }

    return null;
  }

  String? validatePassword() {
    final text = passwordText.value;
    if (text.isEmpty) {
      passwordError("Şifre alanı boş olamaz");
      return passwordError.value;
    }

    if (text.length < 6) {
      passwordError("Şifre en az 6 karakter olmalıdır");
      return passwordError.value;
    }

    passwordError("");
    return null;
  }

  String gunCevir(String gun) {
    String veri = 'yok';
    switch (gun) {
      case 'fajr':
        veri = 'Sabah';
        break;
      case 'sunrise':
        veri = 'Güneş';
        break;
      case 'dhuhr':
        veri = 'Öğle';
        break;
      case 'asr':
        veri = 'İkindi';
        break;
      case 'maghrib':
        veri = 'Akşam';
        break;
      case 'isha':
        veri = 'Yatsı';
        break;
    }
    return veri;
  }
}
