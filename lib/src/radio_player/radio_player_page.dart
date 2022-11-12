import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quran_app/bricks/my_widgets/my_button.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/profile/views/signin_page.dart';
import 'package:quran_app/src/quran/model/radio_model.dart';
import 'package:quran_app/src/radio_player/global_player_controller.dart';
import 'package:quran_app/src/radio_player/radio_item.dart';
import 'package:quran_app/src/radio_player/radiyoplayer_kontroler.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';

// ignore: must_be_immutable
class RadioPlayerPage extends StatefulWidget {
  RadioPlayerPage({Key? key}) : super(key: key);
  String? url;

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> {
  var radiokontroller;
  Color renk = Colors.red.shade100;

  @override
  Widget build(BuildContext context) {
    // final surahFavoriteC = Get.put(SurahFavoriteController());
    final userC = Get.put(UserControllerImpl());
    final player = Get.put(GlobalPlayerController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Radyo",
          style: AppTextStyle.bigTitle,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          RadioKontroller(
            url: widget.url,
          ),
          IconButton(
            onPressed: () {
              player.playMusic();
            },
            icon: Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {
              player.stopMusic();
            },
            icon: Icon(Icons.play_arrow),
          ),
          Expanded(
            child: Obx(
              () => userC.user.email == null
                  ? FadeIn(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/illustration/cannot-access-state.svg",
                              width: 190,
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "Giriş Yap ...",
                              style: AppTextStyle.bigTitle,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Diyanet ve daha fazla dini \nradyo dinlemek için giriş yapın.",
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            MyButton(
                              width: MediaQuery.of(context).size.width * 0.7,
                              text: "Giriş Yap",
                              onPressed: () => Get.to(SignInPage()),
                            ),
                          ],
                        ),
                      ),
                    )
                  : FutureBuilder(
                      future: vericek(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Radioitem> listem =
                              snapshot.data as List<Radioitem>;
                          if (listem.isEmpty) {
                            return const Center(
                              child: Text("Radio Bulunamadı"),
                            );
                          } else {
                            return ListView.separated(
                                itemCount: listem.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                itemBuilder: (context, i) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FadeInDown(
                                        child: InkWell(
                                          highlightColor: Colors.white12,
                                          splashColor: Colors.white12,
                                          onTap: () {
                                            widget.url = listem[i].url;
                                            setState(() {});
                                          },
                                          child: RadioitemCard(
                                            number: listem[i].id,
                                            nameShort: listem[i].radioadi,
                                            nameTransliteration:
                                                listem[i].radioadi,
                                            revelation: listem[i].radioaciklama,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (ctx, i) {
                                  return const SizedBox(height: 10);
                                });
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  vericek() async {
    var veri = await radiokontroller.getListRadio();
    return veri;
  }
}
