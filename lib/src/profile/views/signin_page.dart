import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:quran_app/bricks/my_widgets/google_button_1.dart';
import 'package:quran_app/bricks/my_widgets/input_text.dart';
import 'package:quran_app/bricks/my_widgets/my_button.dart';
import 'package:quran_app/src/app.dart';
import 'package:quran_app/src/profile/controllers/auth_controller.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/profile/formatter/response_formatter.dart';
import 'package:quran_app/src/profile/views/signup_page.dart';
import 'package:quran_app/src/settings/controller/settings_controller.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';

import '../../../helper/global_state.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final settingController = Get.put(SettingsController());
  final authController = Get.put(AuthControllerImpl());
  final userController = Get.put(UserControllerImpl());
  final _state = Get.put(GlobalState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kuran-ı Kerim App",
          style: AppTextStyle.bigTitle,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text(
                "Hoşgeldiniz!",
                style: AppTextStyle.bigTitle.copyWith(
                  fontSize: 28,
                  color: settingController.isDarkMode.value
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tekrar Hoşgeldin \nHemen Giriş Yap !",
                style: AppTextStyle.normal.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              InputText(
                textController: _emailC,
                hintText: "Email",
                prefixIcon: Icon(
                  IconlyLight.message,
                  color: Theme.of(context).primaryColor,
                ),
                onChanged: (v) {
                  _state.emailText(v);
                },
              ),
              const SizedBox(height: 10),
              Obx(
                () => InputText(
                  textController: _passwordC,
                  hintText: "Şifre",
                  errorText: _state.passwordError.isNotEmpty
                      ? _state.passwordError.value
                      : null,
                  prefixIcon: Icon(
                    IconlyLight.password,
                    color: Theme.of(context).primaryColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _state.isObscure(!_state.isObscure.value),
                    icon: Icon(
                      _state.isObscure.isTrue
                          ? IconlyLight.hide
                          : IconlyLight.show,
                      color: Colors.grey,
                    ),
                  ),
                  obsureText: _state.isObscure.value,
                  onChanged: (v) {
                    if (v.isEmpty) {
                      _state.passwordError("");
                    }
                    _state.passwordText(v);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => MyButton(
                  width: MediaQuery.of(context).size.width,
                  text: "Giriş Yap",
                  isLoading: _state.isLoading.value,
                  onPressed: () => signIn(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Diğer Seçenekler",
                style: AppTextStyle.normal.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Obx(
                () => GoogleBtn1(
                  text: "Google İle Giriş Yap",
                  isLoading: _state.isLoadingGoogle.value,
                  onPressed: () => signInWithGoogle(),
                ),
              ),
              const SizedBox(height: 70),
              Text(
                "Hala üye değil misin ?",
                style: AppTextStyle.normal.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () => Get.off(SignUpPage()),
                child: Text(
                  "Hemen Üye Ol",
                  style: AppTextStyle.normal.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    _state.isSubmitted(true);
    final email = _state.validateEmail();
    final pass = _state.validatePassword();
    if (email != null) {
      Get.snackbar("Opps... asdasdasd", email);
      _state.isSubmitted(false);
    } else if (pass != null) {
      Get.snackbar("Opps...fghfghfh", pass);
      _state.isSubmitted(false);
    } else {
      _state.isSubmitted(false);

      _state.isLoading(true);
      authController
          .signIn(_emailC.text, password: _passwordC.text)
          .then((result) {
        if (result.error != null) {
          _state.isLoading(false);

          Get.snackbar("Opps... fghfghfgh", result.error.toString());
        } else {
          userController.loadUser(result.user?.email).then((value) {
            _state.isLoading(false);
            Get.offAll(const MainPage());
          });
        }
      });
    }
  }

  void signInWithGoogle() async {
    _state.isLoadingGoogle(true);
    UserResultFormatter googleUser = await authController.signInWithGoogle();
    if (googleUser.error != null) {
      _state.isLoadingGoogle(false);
      Get.snackbar("Opps...werwer", googleUser.error.toString());
    } else {
      final userResult = await userController.loadUser(googleUser.user?.email);

      if (userResult.error != null) {
        _state.isLoadingGoogle(false);

        Get.snackbar("Opps... asdasd ", "${userResult.error}, please register!");
      } else {
        authController.signIn(userResult.user!.email.toString()).then((result) {
          _state.isLoadingGoogle(false);

          if (result.error != null) {
            Get.snackbar("Opps...erter ", result.error.toString());
          } else {
            userController.loadUser(result.user?.email).then((value) {
              Get.offAll(const MainPage());
            });
          }
        });
      }
    }
  }
}
