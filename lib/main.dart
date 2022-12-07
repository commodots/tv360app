import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_tv_360/pages/favourite_articles.dart';
import 'package:new_tv_360/pages/search.dart';
import 'package:new_tv_360/pages/settings.dart';
import 'package:new_tv_360/pages/local_articles.dart';
import 'package:new_tv_360/pages/about_us.dart';
import 'package:new_tv_360/pages/news_categories.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TV360 Nigeria',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF385C7B),
          accentColor: const Color(0xFFE74C3C),
          textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 17, color: Colors.black,
                height: 1.2, fontWeight: FontWeight.w500, fontFamily: "Soleil",),
              caption: TextStyle(color: Colors.black45, fontSize: 10),
              bodyText1: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87,
              )),
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _notification = false;
  // Firebase Cloud Messeging setup
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const Articles(),
    const LocalArticles(),
    const Search(),
    const Settings(),
    const AboutUs(),
    const Categories()
  ];


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
  void initState() {
    checkNotificationSetting();
    super.initState();
  }

  startFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 1) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(message.notification!.title!, style: const TextStyle(fontFamily: "Soleil", fontSize: 18),
                ),
                content: Text(message.notification!.body!),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("Dismiss"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        onError: (error){
        print(error.toString());
        },
        onDone: (){
          // print("onResume: $message");
        },
      );
      _firebaseMessaging.getToken().then((token) {
        // print("Firebase Token:" + token);
      });
    }
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontFamily: "Soleil"),
          unselectedLabelStyle: const TextStyle(fontFamily: "Soleil"),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.flare), label: PAGE2_CATEGORY_NAME),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed),
    );
  }

  void _onItemTapped(int index) {
       setState(() {
      _selectedIndex = index;
    });
  }
}