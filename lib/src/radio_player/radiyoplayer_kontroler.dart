import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioKontroller extends StatefulWidget {
  const RadioKontroller({Key? key, this.url}) : super(key: key);
  final String? url;

  @override
  State<RadioKontroller> createState() => _RadioKontrollerState();
}

class _RadioKontrollerState extends State<RadioKontroller> {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Center(
        child: MaterialButton(
          onPressed: () async {
            if (widget.url == null) {
              Get.snackbar('Hata', 'Radio Sçiniz');
            } else {
              radioCal(widget.url!);
            }
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            ikon,
            size: 40,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  radioCal(String url) async {
    if (url.isEmpty) {
      log("radio yok");
    }
    if (caliyormu == false) {
      setState(() {
        ikon = Icons.file_download;
      });
      await advancedPlayer.setSourceUrl(url);
      await advancedPlayer.resume();
      setState(() {
        ikon = Icons.pause;
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
