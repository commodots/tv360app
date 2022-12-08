import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../main.dart';
import '../widgets/searchBoxes.dart';
import 'category_articles.dart';
import 'favourite_articles.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  ScrollController? _scrollController;



  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'News Categories',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins'),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50,),
            ...List.generate(CUSTOM_CATEGORIES.length, (index) {
              var cat = CUSTOM_CATEGORIES[index];
              var name = cat[0];
              var image = cat[1];
              var catId = cat[2];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryArticles(catId, name),),);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 16, 8, 8),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: double.maxFinite, height: 35,
                            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(image, height: 70, width: 70,),
                            const SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                name, textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20, height: 1.2, fontWeight: FontWeight.w500,),
                              ),
                            )
                          ],
                        )),
                        // const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            })
            // searchPosts(_futureSearchedArticles!)
          ],
        ),
      )
    );
  }
}
