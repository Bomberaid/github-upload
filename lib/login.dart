import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var session = FlutterSession();

  final TextEditingController _accessKeyController =
      new TextEditingController();
  final TextEditingController _secretKeyController =
      new TextEditingController();
  final TextEditingController _hostController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    waitForKey();
  }

  // Used to fill in textfields with previous values.
  void waitForKey() async {
    _accessKeyController.text = await session.get("accessKey");
    _secretKeyController.text = await session.get("secretKey");
    _hostController.text = await session.get("host");
  }

  @override
  void dispose() {
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    _hostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "API Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
              ),
              SizedBox(
                height: 50,
              ),

              // Access key textfield.
              TextField(
                controller: _accessKeyController,
                decoration: InputDecoration(hintText: "Access Key"),

                // Changes the value of [accessKey] whenever the textfield changes.
                // Although there are many warnings for some reason.
                onChanged: (value) async {
                  await session.set("accessKey", value);
                },
              ),
              SizedBox(
                height: 10,
              ),

              // Secret Key textfield.
              TextField(
                controller: _secretKeyController,
                decoration: InputDecoration(hintText: "Secret Key"),

                // Changes the value of [secretKey] whenever the textfield changes.
                // Although there are many warnings for some reason.
                onChanged: (value) async {
                  await session.set("secretKey", value);
                },
              ),
              SizedBox(height: 10),

              // Host key textfield.
              TextField(
                controller: _hostController,
                decoration: InputDecoration(hintText: "Host"),

                // Changes the value of [host] whenever the textfield changes.
                // Although there are many warnings for some reason.
                onChanged: (value) async {
                  await session.set("host", value);
                },
              ),
              SizedBox(
                height: 50,
              ),
              Builder(
                  builder: (context) => CupertinoButton(
                      child: Text("Submit"),
                      color: Colors.red[600],
                      onPressed: () async {
                        final accessKey = await session.get("accessKey");
                        final secretKey = await session.get("secretKey");
                        final host = await session.get("host");

                        // Checks to see if textFields have values or not empty...
                        if (accessKey != null &&
                            secretKey != null &&
                            host != null) {
                          session.set("dataIn", true);

                          // ... and resets the app to trigger the main screen.
                          Phoenix.rebirth(context);
                        }
                      })),
              SizedBox(
                height: 50,
              ),

              // Hyperlink that takes user to ACRCloud website to get API keys.
              RichText(
                  text: TextSpan(
                      text: "Don't have the keys?",
                      style: TextStyle(color: Colors.blue[300]),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          var url =
                              "https://console.acrcloud.com/avr?region=eu-west-1#/login?redirect=%2Fdashboard";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw "Can't find $url";
                          }
                        }))
            ],
          ),
        ),
      ),
    );
  }
}
