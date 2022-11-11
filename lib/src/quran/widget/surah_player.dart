import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SurahOynat extends StatefulWidget {
  const SurahOynat({Key? key, this.url}) : super(key: key);
  final String? url;
  @override
  State<SurahOynat> createState() => _SurahOynatState();
}

class _SurahOynatState extends State<SurahOynat> {
  AudioPlayer advancedPlayer = AudioPlayer();
  bool caliyormu = false;

  @override
  void initState() {
    super.initState();
    advancedPlayer.onPlayerComplete.listen((event) {
      setState(() {
        caliyormu = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        gelenLinkiCalistir(widget.url);
      }),
      child: Chip(
        backgroundColor: Theme.of(context).cardColor,
        label: Icon(caliyormu ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  gelenLinkiCalistir(String? url) async {
    if (caliyormu == false) {
      await advancedPlayer.setSourceUrl(url!);
      await advancedPlayer.resume();
      setState(() {
        caliyormu = true;
      });
    } else {
      advancedPlayer.pause();
      setState(() {
        caliyormu = false;
      });
    }
  }
}
