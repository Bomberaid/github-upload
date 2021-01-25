import 'package:anime_opener/acr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';
import 'dart:convert';

import './anime_page.dart';
import './waveform.dart';
import './login.dart';

class Recognize extends StatefulWidget {
  const Recognize({Key key, this.host, this.accessKey, this.secretKey})
      : super(key: key);

  final String host;
  final String accessKey;
  final String secretKey;

  @override
  _RecognizeState createState() => _RecognizeState();
}

class _RecognizeState extends State<Recognize> {
  ACRCloudResponseMusicItem music; // Stores music data from API.
  Acr acr = new Acr(); // Triggers API methods.
  String animeName;
  String picture;
  String artist;

  var pressed = false; // Checks to see if user is currently listening.

  var waveform =
      new Waveform(); // Method that triggers waveform graphic animation.
  bool togglePlay; // Toggles waveform graphic on and off.
  Artboard board; // Used to display waveform graphic as widget.

  void initState() {
    super.initState();
    // ACRCloud.setUp(ACRCloudConfig(
    //     "08f0053122f0233ae7d9460526b090fa",
    //     "QsM9RZkc70bXjTlsvZgMOwGNJfFs0rQnfUdDxel2",
    //     "identify-us-west-2.acrcloud.com"));

    // Resets ACRCloud information
    ACRCloud.isSetUp = false;

    // Sets up ACRCloud API
    ACRCloud.setUp(
        ACRCloudConfig(widget.accessKey, widget.secretKey, widget.host));

    board = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],

      // Opens a drawer that leads to Login screen.
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Change API Info"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Stack(
          children: [
            // Settings button.
            Align(
              alignment: Alignment(-1, -1),
              child: Builder(
                builder: (context) => CupertinoButton(
                    child: Icon(Icons.settings),
                    onPressed: () => Scaffold.of(context).openDrawer()),
              ),
            ),

            // Waveform Graphic.
            Flex(direction: Axis.vertical, children: [
              Expanded(
                  child: board == null
                      ? const SizedBox()
                      : waveform.isPlaying()
                          ? Rive(artboard: board)
                          : const SizedBox()),
            ]),

            // Listen button that triggers API.
            Align(
              alignment: Alignment.bottomCenter,
              child: Builder(
                  builder: (context) => CupertinoButton(
                      color: Colors.red[600],
                      onPressed: () async {
                        board = await waveform.board();

                        // Toogles the waveform graphic on.
                        setState(() {
                          waveform.togglePlay(true);
                        });

                        if (!pressed) {
                          pressed = true;
                          acr.createSession();

                          final result = await acr.session.result;

                          if (result != null && result.metadata != null) {
                            music = result.metadata.music.first;
                            artist = music.artists[0].name;

                            // Gets anime name and associated picture from the music title.
                            // [returnAnime] uses a json structure to acomplish this.
                            animeName = await returnAnime(music.title);
                            picture = await returnAnime(music.title,
                                returnType: "picture");

                            // Once all information is found, change to results screen.
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Anime(
                                          animeName: animeName,
                                          picture: picture,
                                          song: music.title,
                                          artist: artist,
                                        )));

                            pressed = false;
                          } else {
                            // If API wasn't able to find song, returns an alert with no result.
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("No Result"),
                              duration: Duration(milliseconds: 500),
                            ));
                            pressed = false;
                          }
                        } else {
                          // If users hits listen button again, cancels recording.
                          acr.endSession();
                          pressed = false;
                        }
                        setState(() {
                          waveform.togglePlay(false);
                        });
                      },

                      // Represents buttons to record and cancel
                      // depending on if user is already listening.
                      child: !pressed ? Icon(Icons.mic) : Icon(Icons.mic_off))),
            ),
          ],
        ),
      ),
    );
  }
}

/// Returns anime name or picture from song.
/// There are two [returnType].
/// "name" returns anime name.
/// "picture" returns picture of anime.
/// By default, "name" is used.
Future<String> returnAnime(String songTitle,
    {String returnType = "name"}) async {
  final data = await rootBundle.loadString("assets/Anime_Data.txt");
  final jsonData = json.decode(data) as Map;

  // Finds any string encased in parentheses.
  final excessData = RegExp(r"\((.+)\)");

  var anime = new List();
  var finalAnime;
  var modifiedName;

  // If there are no strings encased in parentheses...
  if (excessData.hasMatch(songTitle) == false) {
    // ... removes all spaces from inputed song name.
    modifiedName = songTitle.toLowerCase().replaceAll(" ", "");
  }
  // If there are parentheses...
  else {
    /// ... removes them from song name and any spaces.
    var garbage = excessData.stringMatch(songTitle);
    modifiedName =
        songTitle.replaceAll("$garbage", "").replaceAll(" ", "").toLowerCase();
  }

  // Compares song name with anime openings in json file.
  jsonData.forEach((key, value) {
    // If the song has Japanese characters...
    if (RegExp("[\u3040-\u30ff]").hasMatch(songTitle)) {
      // ... looks for openings in the Japanese section.
      for (String name in value["jp_song_name"]) {
        // If there is a match, returns the key as the anime name.
        // If there are multiple matches, adds keys to a list.
        if (name.replaceAll(" ", "") == modifiedName) {
          anime.add(key);
        }
      }
    }
    // If the song has English characters...
    else {
      // ... finds openings with English names.
      for (String name in value["eng_song_name"]) {
        // If there is a match, returns key.
        // [replaceAll] and [toLowerCase] are used to remove any sources of error.
        if (name.replaceAll(" ", "").toLowerCase() == modifiedName) {
          anime.add(key);
        }
      }
    }
  });

  // If anime is found, always returns the first result.
  // First result is used because it is the most popular result and likely the correct anime.
  // Of course, there will be multiple instances where the returned anime will be incorrect.
  if (anime != null && anime.length > 0) finalAnime = anime.first;

  // Returns anime name or picture depending on inputted parameters.
  if (returnType.toLowerCase() == "name") {
    return finalAnime;
  } else if (returnType.toLowerCase() == "picture" && finalAnime != null) {
    return jsonData[finalAnime]["picture"];
  } else {
    print("Couldn't Find Anime");
    return null;
  }
}
