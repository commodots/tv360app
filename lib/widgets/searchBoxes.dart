
import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/category_articles.dart';


Widget searchBoxes(BuildContext context) {
  return GridView.count(
    padding: const EdgeInsets.all(16),
    shrinkWrap: true,
    physics: const ScrollPhysics(),
    crossAxisCount: 3,
    children: List.generate(CUSTOM_CATEGORIES.length, (index) {
      var cat = CUSTOM_CATEGORIES[index];
      var name = cat[0];
      var image = cat[1];
      var catId = cat[2];

      return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryArticles(catId, name),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(
              children: <Widget>[
                SizedBox(width: 100, height: 45, child: Image.asset(image)),
                const Spacer(),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, height: 1.2, fontWeight: FontWeight.w500,),
                )
              ],
            ),
          ),
        ),
      );
    }),
  );
}
