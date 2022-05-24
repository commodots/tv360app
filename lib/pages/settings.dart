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
      resizeToAvoidBottomInset: false,
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
              child:
              const Image(
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
             physics: const BouncingScrollPhysics(),
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
                   leading: Icon(Icons.star_outline_rounded, color: Color(0xFF084374), size: 30,),
                   // Image.asset(
                   //   "assets/more/favourite.png",
                   //   width: 30,
                   // ),
                   title: const Text('Favourite'),
                   subtitle: const Text("See the saved news article"),
                 ),
               ),
               ListTile(
                 leading: Icon(Icons.email_outlined, color: Color(0xFF084374), size: 30,),
                 title: const Text('Email Us'),
                 subtitle: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Row(children: [
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
                       SizedBox(width: MediaQuery.of(context).size.width /25,),
                       FlatButton(
                           padding: const EdgeInsets.all(0),
                           onPressed: () async {
                             const url = 'mailto:tv360nigeria@gmail.com';
                             if (await canLaunch(url)) {
                               await launch(url);
                             } else {
                               throw 'Could not launch $url';
                             }
                           },
                           child: const Text(
                             "tv360nigeria@gmail.com",
                             style: TextStyle(color: Colors.black54),
                           )),
                     ],),
                   ],
                 ),
               ),
               ListTile(
                 leading: Icon(Icons.phone, color: Color(0xFF084374), size: 30,),
                 // Image.asset(
                 //   "assets/more/contact.png",
                 //   width: 30,
                 // ),
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

                     Row(
                         children:[
                           FlatButton(
                               padding: const EdgeInsets.all(0),
                               onPressed: () async {
                                 const url = 'tel:+2347026148435';
                                 if (await canLaunch(url)) {
                                   await launch(url);
                                 } else {
                                   throw 'Could not launch $url';
                                 }
                               },
                               child: const Text(
                                 "07026148435",
                                 style: TextStyle(color: Colors.black54),
                               )),

                           FlatButton(
                               padding: const EdgeInsets.all(0),
                               onPressed: () async {
                                 const url = 'tel:+2348130138832';
                                 if (await canLaunch(url)) {
                                   await launch(url);
                                 } else {
                                   throw 'Could not launch $url';
                                 }
                               },
                               child: const Text(
                                 "08130138832", style: TextStyle(color: Colors.black54),
                               )
                           ),]
                     )
                   ],
                 ),
               ),
               InkWell(
                 onTap: () {
                   Share.share(
                       'Check out our app on Adnroid & ios: https://www.tv360nigeria.com');
                 },
                 child: ListTile(
                   leading: Icon(Icons.share_outlined, color: Color(0xFF084374), size: 30,),
                   // Image.asset(
                   //   "assets/more/share.png",
                   //   width: 30,
                   // ),
                   title: const Text('Share'),
                   subtitle: const Text("Spread the words of flutter blog crumet"),
                 ),
               ),
               ListTile(
                 leading: Icon(Icons.notifications_active_outlined, color: Color(0xFF084374), size: 30,),
                 // Image.asset(
                 //   "assets/more/notification.png",
                 //   width: 30,
                 // ),
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
           ),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 48.0),
                  child: Text("Follow Us on Social Media", style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black54, fontSize: 25),),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Expanded(child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    "assets/facebook_logo.jpg",
                    width: 30,
                  ),
                  title: const Text('Facebook'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://www.facebook.com/Tv360online/';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "www.facebook.com/Tv360online",
                            style: TextStyle(color: Colors.black54),
                          )),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/youtube_logo.png",
                    width: 30, height: 30,
                  ),
                  title: const Text('Youtube'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://www.youtube.com/user/TV360NIGERIA';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "www.youtube.com/tv360nigeria",
                            style: TextStyle(color: Colors.black54),
                          )),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/instagram_logo.png",
                    width: 30, height: 30,
                  ),
                  title: const Text('Instagram'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://www.instagram.com/tv360nigeria';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "www.instagram.com/tv360nigeria",
                            style: TextStyle(color: Colors.black54),
                          )),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/linkedin_logo.png",
                    width: 30, height: 30,
                  ),
                  title: const Text('LinkedIn'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://www.linkedin.com/showcase/tv360nigeria';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "www.linkedin.com/tv360nigeria",
                            style: TextStyle(color: Colors.black54),
                          )),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/twitter_logo.png",
                    width: 30, height: 30,
                  ),
                  title: const Text('Twitter'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://twitter.com/tv360nigeria';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text(
                            "www.twitter.com/tv360nigeria",
                            style: TextStyle(color: Colors.black54),
                          )),
                    ],
                  ),
                ),
              ],
            ),))
          ],
        ),
      ),
    );
  }
}
