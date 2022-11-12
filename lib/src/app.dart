import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quran_app/src/home/view/home_page.dart';
import 'package:quran_app/src/prayer_time/views/qiblat_page.dart';
import 'package:quran_app/src/quran/view/favorite_page.dart';
import 'package:quran_app/src/quran/view/surah_page.dart';
import 'package:quran_app/src/radio_player/global_player_controller.dart';
import 'package:quran_app/src/routes.dart';
import 'package:quran_app/src/settings/controller/settings_controller.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/wrapper.dart';
import 'package:unicons/unicons.dart';
import 'package:wiredash/wiredash.dart';

import 'radio_player/radio_player_page.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _navigatorKey = GlobalKey<NavigatorState>();
  final player = Get.put(GlobalPlayerController());
  final settingC = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wiredash(
        projectId: "hiquran-la8pogf",
        secret: "Sn698m834hExb9tINXq1pdXjSRGMMAFs",
        navigatorKey: _navigatorKey,
        theme: WiredashThemeData(
          brightness:
              settingC.isDarkMode.value ? Brightness.dark : Brightness.light,
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          title: 'KuranApp',
          darkTheme: AppTheme.dark,
          theme: AppTheme.light,
          // home: SignInPage(),
          home: Wrapper(),
          // home: HomePage(),
          // home: UploadAvatarPage(),
          // home: MainPage(),
          // initialRoute: "/",
          getPages: Routes.pages,
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    HomePage(),
    SurahPage(),
    // PrayerTimePage(),
    QiblatPage(),
    // SettingsPage(),
    const FavoritePage(),
    // ProfilePage(),
    RadioPlayerPage()
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [AppShadow.card],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 10,
              activeColor: Theme.of(context).primaryColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
              color: Colors.grey,
              tabMargin: const EdgeInsets.only(top: 4),
              textStyle: AppTextStyle.normal.copyWith(
                color: Theme.of(context).primaryColor,
              ),
              tabs: const [
                GButton(
                  icon: UniconsLine.home_alt,
                  text: "Anasayfa",
                ),
                GButton(
                  icon: UniconsLine.book_open,
                  text: 'Kuran',
                ),
                GButton(
                  icon: UniconsLine.compass,
                  text: 'Kıble',
                ),
                GButton(
                  icon: UniconsLine.heart,
                  text: 'Favori',
                ),
                GButton(
                  icon: UniconsLine.play,
                  text: 'Radyo',
                )
              ],
              selectedIndex: _index,
              onTabChange: (index) {
                setState(() {
                  _index = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
