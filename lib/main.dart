import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'models/music.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => App();
}

class App extends State<MyStatefulWidget> {
  bool isPlayed = false;
  List<Music> musicList = [
    Music(
      "World of Wonk",
      "MONXX",
      "assets/pictures/world_of_wonk.jpg",
      "assets/musics/wonk.mp3",
    ),
    Music(
      "Druid",
      "D-Charged & Neolite",
      "assets/pictures/druid.jpg",
      "assets/musics/fight.mp3",
    ),
    Music(
      "Fight The Hardest",
      "MYST",
      "assets/pictures/myst-fight-the-hardest.jpg",
      "assets/musics/druid.mp3",
    ),
  ];
  int musicIndex = 0;
  final _player = AudioPlayer();
  String musicDuration = "";
  String musicPosition = "";

  @override
  void initState() {
    super.initState();
    initSong();
  }

  void togglePlayed() {
    if (isPlayed == true) {
      _player.pause();
    } else {
      _player.play();
    }
    musicPosition =
        "${_player.position.inMinutes}:${_player.position.inSeconds % 60}";
    setState(() {
      isPlayed = !isPlayed;
    });
  }

  Future<void> initSong() async {
    await _player.setAsset(musicList[musicIndex].urlSong);
    musicDuration =
        "${_player.duration!.inMinutes}:${_player.duration!.inSeconds % 60}";
    musicPosition = "0:0";
    setState(() {
      _player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Matthiasify'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.pink[900]!,
            Colors.black87,
          ],
        )),
        padding: const EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          Image.asset(musicList[musicIndex].imagePath,
              width: 340, height: 340, fit: BoxFit.cover),
          Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                musicList[musicIndex].title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: const TextStyle(color: Colors.white, fontSize: 28),
              )),
          Text(
            musicList[musicIndex].singer,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: const TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w300),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () => {
                      setState(() {
                        if (musicIndex == 0) {
                          musicIndex = musicList.length - 1;
                        } else {
                          musicIndex--;
                        }
                        initSong();
                      })
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                    iconSize: 44.0,
                  ),
                  IconButton(
                    onPressed: () => togglePlayed(),
                    icon: isPlayed
                        ? const Icon(
                            Icons.pause,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                    iconSize: 44.0,
                  ),
                  IconButton(
                    onPressed: () => {
                      setState(() {
                        if (musicIndex == musicList.length - 1) {
                          musicIndex = 0;
                        } else {
                          musicIndex++;
                        }
                        initSong();
                      })
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                    ),
                    iconSize: 44.0,
                  ),
                ],
              )),
          Text(
            "$musicPosition/$musicDuration",
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ]),
      ),
    );
  }
}

enum PlayerState { play, pause }
