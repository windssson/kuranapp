
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/src/quran/widget/surah_player.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';

class SurahCard extends StatefulWidget {
  const SurahCard({
    Key? key,
    this.number,
    this.nameTransliteration,
    this.nameShort,
    this.numberOfVerses,
    this.audiourl,
    this.nameTranslation,
  }) : super(key: key);
  final int? number;
  final String? nameTransliteration;
  final String? nameTranslation;
  final String? nameShort;
  final int? numberOfVerses;
  final String? audiourl;

  @override
  State<SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<SurahCard> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  bool playerstate = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [AppShadow.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  "${widget.number}",
                  style: AppTextStyle.normal.copyWith(
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${widget.nameTransliteration}",
            style: AppTextStyle.title.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            "${widget.nameTranslation}",
            style: AppTextStyle.normal.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SurahOynat(url: widget.audiourl,),
              const SizedBox(width: 8),
              Chip(
                backgroundColor: Theme.of(context).cardColor,
                label: Text(
                  "${widget.numberOfVerses} Ayet",
                  style: AppTextStyle.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

