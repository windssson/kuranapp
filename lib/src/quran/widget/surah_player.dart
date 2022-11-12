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
  IconData ikon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    advancedPlayer.onPlayerComplete.listen((event) {
      setState(() {
        caliyormu = false;
        ikon = Icons.play_arrow;
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
        label: Icon(ikon),
      ),
    );
  }

  gelenLinkiCalistir(String? url) async {
    if (caliyormu == false) {
      setState(() {
        ikon = Icons.file_download;
      });
      await advancedPlayer.setSourceUrl(url!);
      await advancedPlayer.resume();
      setState(() {
        ikon = Icons.pause;
        caliyormu = true;
      });
    } else {
      advancedPlayer.pause();
      setState(() {
        caliyormu = false;
        ikon = Icons.play_arrow;
      });
    }
  }
}
