import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_tv_360/pages/single_article.dart';


import '../constants.dart';
import '../models/article.dart';
import '../widgets/articleBox.dart';
import '../widgets/articleBoxFeatured.dart';

class Articles extends StatefulWidget {

  const Articles({Key? key}) : super(key: key);
  @override
  _ArticlesState createState() => _ArticlesState();
}

const int maxAttempt = 3;

class _ArticlesState extends State<Articles> {


  static const AdRequest request = AdRequest(
    // keywords: ["",""],
    // contentUrl: "",
    // nonPersonalizedAds: false,
  );

  bool staticAdLoaded = false;
  bool inlineAdLoaded = false;
  late BannerAd staticAd;
  late BannerAd inlineAd;

  void loadStaticBannerAd(){
    staticAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId:
        //BannerAd.testAdUnitId,
        Platform.isAndroid ? "ca-app-pub-5997714789549502/9405480446" : "ca-app-pub-5997714789549502/3104614212",
        listener: BannerAdListener(
            onAdLoaded: (ad){
              setState(() {
                staticAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              print("ad Failed to load ${error.message}");
            }
        ),
        request: request
    );
    staticAd.load();
  }

  void loadInlineBannerAd(){
    inlineAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId:
        //BannerAd.testAdUnitId,
        Platform.isAndroid ? "ca-app-pub-5997714789549502/9405480446" : "ca-app-pub-5997714789549502/3104614212",
        listener: BannerAdListener(
            onAdLoaded: (ad){
              setState(() {
                inlineAdLoaded = true;
              });},
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              print("ad Failed to load ${error.message}");
            }
        ),
        request: request
    );
    inlineAd.load();
  }

  List<dynamic> featuredArticles = [];
  List<dynamic> latestArticles = [];
  Future<List<dynamic>>? _futureLastestArticles;
  Future<List<dynamic>>? _futureFeaturedArticles;
  ScrollController? _controller;
  int page = 1;
  bool? _infiniteStop;

  @override
  void initState() {
    super.initState();
    loadInlineBannerAd();
    loadStaticBannerAd();
    _futureLastestArticles = fetchLatestArticles(1);
    _futureFeaturedArticles = fetchFeaturedArticles(1);
    _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller?.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  Future<List<dynamic>> fetchLatestArticles(int page) async {
    try {
      var response = await http.get(Uri.parse('$WORDPRESS_URL/wp-json/wp/v2/posts/?page=$page&per_page=10&_fields=id,date,title,content,custom,link'));
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            latestArticles.addAll(json.decode(response.body).map((m) => Article.fromJson(m)).toList());
            if (latestArticles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });
          return latestArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return latestArticles;
  }

  Future<List<dynamic>> fetchFeaturedArticles(int page) async {
    try {
      var response = await http.get(Uri.parse("$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$FEATURED_ID&page=$page&per_page=10&_fields=id,date,title,content,custom,link"));

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            featuredArticles.addAll(json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList());
          });

          return featuredArticles;
        } else {
          setState(() {
            _infiniteStop = true;
          });
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return featuredArticles;
  }

  _scrollListener() {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureLastestArticles = fetchLatestArticles(page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Image(
            image: AssetImage('assets/icon.png'),
            height: 45,
          ),
          elevation: 5,
          backgroundColor: const Color(0xff030f29),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white70),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _controller,
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                if(staticAdLoaded)
                //   Container(
                //   child: AdWidget(ad: staticAd),
                //   width: staticAd.size.width.toDouble(),
                //   height: staticAd.size.height.toDouble(),
                //   alignment: Alignment.bottomCenter,
                // ),
                  staticBannerAdWidget(),
                featuredPost(_futureFeaturedArticles!),
                latestPosts(_futureLastestArticles!),
              ],
            ),
          ),
        ));
  }

  Widget inlineBannerAdWidget() {
    return StatefulBuilder(
      builder: (context, setState) =>  Container(
        child: AdWidget(ad: inlineAd),
        width: inlineAd.size.width.toDouble(),
        height: inlineAd.size.height.toDouble(),
        alignment: Alignment.bottomCenter,
      ),
    );
  }


  Widget staticBannerAdWidget() {
    return StatefulBuilder(
      builder: (context, setState) =>  Container(
        child: AdWidget(ad: staticAd),
        width: staticAd.size.width.toDouble(),
        height: staticAd.size.height.toDouble(),
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget latestPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data?.length == 0) return Container();
            return Column(
              children: <Widget>[
                Column(
                    children: [
                      ...articleSnapshot.data!.map((item) {
                        final heroId = item.id.toString() + "-latest";
                        return Column(
                          children: [
                            if(inlineAdLoaded && articleSnapshot.data!.indexOf(item) > 1)
                              inlineBannerAdWidget(),
                              // Container(
                              //   child: AdWidget(ad: inlineAd),
                              //   width: inlineAd.size.width.toDouble(),
                              //   height: inlineAd.size.height.toDouble(),
                              //   alignment: Alignment.bottomCenter,
                              // ),
                            const SizedBox(height: 10,),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SingleArticle(item, heroId),),
                                );
                              },
                              child: articleBox(context, item, heroId),
                            ),
                          ],
                        );
                      }).toList()
                    ]
                ),
                !_infiniteStop!
                    ? Container(
                    alignment: Alignment.center,
                    height: 30,
                    child: LoadingAnimationWidget.waveDots(
                        size: 60.0,
                        color: Theme.of(context).accentColor))
                    : Container()
              ],
            );
        } else if (articleSnapshot.hasError) {
          return Container(
            child: Text("${articleSnapshot.error}"),
          );
        }
        return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: LoadingAnimationWidget.waveDots(
                size: 60.0,
                color: Theme.of(context).accentColor));
      },
    );
  }

  Widget featuredPost(Future<List<dynamic>> featuredArticles) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<dynamic>>(
        future: featuredArticles,
        builder: (context, articleSnapshot) {
          if (articleSnapshot.hasData) {
            if (articleSnapshot.data?.length == 0) return Container();
            return Row(
                children: articleSnapshot.data!.map((item) {
                  final heroId = item.id.toString() + "-featured";
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleArticle(item, heroId),
                          ),
                        );
                      },
                      child: articleBoxFeatured(context, item, heroId));
                }).toList());
          } else if (articleSnapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/no-internet.png",
                    width: 250,
                  ),
                  const Text("No Internet Connection."),
                  FlatButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reload"),
                    onPressed: () {
                      _futureLastestArticles = fetchLatestArticles(1);
                      _futureFeaturedArticles = fetchFeaturedArticles(1);
                    },
                  )
                ],
              ),
            );
          }
          return Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 280,
              child: LoadingAnimationWidget.waveDots(
                  size: 60.0,
                  color: Theme.of(context).accentColor));
        },
      ),
    );
  }
}
