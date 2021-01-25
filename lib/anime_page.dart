import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Anime extends StatelessWidget {
  Anime({this.animeName, this.picture, this.song, this.artist});

  final String animeName;
  final String picture;
  final String song;
  final String artist;

  // Used in conjuction with "Couldn't Find Anime".
  final emotes = [
    "＞︿＜",
    "＞﹏＜",
    "(っ °Д °;)っ",
    "≡(▔﹏▔)≡",
    "⊙﹏⊙∥",
    "〒▽〒",
    "(´。＿。｀)",
    "X﹏X",
    "ಥ_ಥ",
  ];

  // Randomizes the emotes used in each instance.
  final random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],

        // Checks to see if phone is either in landscape or portrait oreintation.
        // Result layout changes depending on orientation.
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: Stack(
                children: [
                  // Displays anime name.
                  if (animeName != null)
                    Align(
                        alignment: Alignment(0, 0.05),
                        child: Text(
                          animeName,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: "Roboto"),
                          textAlign: TextAlign.center,
                        ))
                  else
                    Container(
                        alignment: Alignment(0, -0.25),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(0, -0.25),
                              child: Text(
                                "Couldn't Find Anime",
                                style: TextStyle(
                                    fontSize: 39,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment(0, -0.1),
                              child: Text(
                                emotes[random.nextInt(emotes.length)],
                                style: TextStyle(
                                    fontSize: 29,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  // Displays anime picture.
                  if (picture != null)
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Image.network(
                        picture,
                        filterQuality: FilterQuality.high,
                        scale: 1.25,
                      ),
                    ),
                  // Displays song name.
                  if (song != null)
                    Stack(children: [
                      Align(
                        alignment: Alignment(0, 0.3),
                        child: Text(
                          song,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.5),
                        child: Text(
                          artist,
                          style:
                              TextStyle(color: Colors.red[600], fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  // Button to go back to home screen.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CupertinoButton(
                        child: Icon(
                          Icons.cancel,
                          size: 30,
                          color: Colors.red[600],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: Stack(
                children: [
                  // Displays anime name.
                  if (animeName != null)
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Align(
                          alignment: Alignment(-1, -0.8),
                          child: Text(
                            animeName,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Roboto"),
                            textAlign: TextAlign.left,
                          )),
                    )
                  else
                    Container(
                        alignment: Alignment(0, -0.25),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(1, 0),
                              child: Text(
                                "Couldn't Find Anime",
                                style: TextStyle(
                                    fontSize: 39,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment(1, 0.3),
                              child: Text(
                                emotes[random.nextInt(emotes.length)],
                                style: TextStyle(
                                    fontSize: 29,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  // Displays anime picture.
                  if (picture != null)
                    Align(
                      alignment: Alignment(0.75, -0.2),
                      child: Image.network(
                        picture,
                        filterQuality: FilterQuality.high,
                        scale: 1.25,
                      ),
                    ),
                  // Displays song name.
                  if (song != null)
                    Stack(children: [
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Align(
                          alignment: Alignment(-1, 0),
                          child: Text(
                            song,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Align(
                          alignment: Alignment(-1, 0.3),
                          child: Text(
                            artist,
                            style:
                                TextStyle(color: Colors.red[600], fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ]),

                  // Button to go back to home screen.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CupertinoButton(
                        child: Icon(
                          Icons.cancel,
                          size: 30,
                          color: Colors.red[600],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            );
          }
        }));
  }
}
