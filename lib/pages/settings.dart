import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'favourite_articles.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notification = false;

  @override
  void initState() {
    super.initState();
    checkNotificationSetting();
  }

  checkNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 0) {
      setState(() {
        _notification = false;
      });
    } else {
      setState(() {
        _notification = true;
      });
    }
  }

  saveNotificationSetting(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'notification';
    final value = val ? 1 : 0;
    prefs.setInt(key, value);
    if (value == 1) {
      setState(() {
        _notification = true;
      });
    } else {
      setState(() {
        _notification = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'More',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins'),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: const Image(
                image: AssetImage('assets/icon.png'),
                height: 50,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: const Text(
                "Version 1.0.0 \n www.tv360nigeria.com \n TV360 Nigeria App for ios and Android",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.6, color: Colors.black87),
              ),
            ),
            const Divider(
              height: 10,
              thickness: 2,
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavouriteArticles(),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.asset(
                      "assets/more/favourite.png",
                      width: 30,
                    ),
                    title: const Text('Favourite'),
                    subtitle: const Text("See the saved news article"),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/more/contact.png",
                    width: 30,
                  ),
                  title: const Text('Contact'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://www.tv360nigeria.com';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "www.tv360nigeria.com",
                            style: TextStyle(color: Colors.black54),
                          )),
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'mailto:enquiries@tv360nigeria.com';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "enquiries@tv360nigeria.com",
                            style: TextStyle(color: Colors.black54),
                          )),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Share.share(
                        'Check out our app on Adnroid & ios: https://www.tv360nigeria.com');
                  },
                  child: ListTile(
                    leading: Image.asset(
                      "assets/more/share.png",
                      width: 30,
                    ),
                    title: const Text('Share'),
                    subtitle: const Text("Spread the words of flutter blog crumet"),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/more/notification.png",
                    width: 30,
                  ),
                  isThreeLine: true,
                  title: const Text('Notification'),
                  subtitle: const Text("Change notification preference"),
                  trailing: Switch(
                      onChanged: (val) async {
                        await saveNotificationSetting(val);
                      },
                      value: _notification),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
