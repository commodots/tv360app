import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import '../models/article.dart';

Widget articleBoxFeatured(
    BuildContext context, Article article, String heroId) {
  return ConstrainedBox(
    constraints: const BoxConstraints(
        minHeight: 280.0, maxHeight: 290.0, minWidth: 360.0, maxWidth: 360.0),
    child: Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 200,
            width: 400,
            child: Card(
              child: Hero(
                tag: heroId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 1,
              margin: const EdgeInsets.all(10),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 155,
          right: 30,
          child: Container(
            alignment: Alignment.bottomRight,
            height: 160,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 15, 140, 15),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Html(
                          data: article.title!.length > 70
                              ? "<h1>" +
                              article.title!.substring(0, 70) +
                              "...</h1>"
                              : "<h1>" + article.title! + "</h1>",
                        style: {
                          // p tag with text_size
                          "h1": Style(
                            fontSize: const FontSize(15),
                            //padding: const EdgeInsets.all(6),
                            backgroundColor: Colors.grey.shade50,
                          ),
                        },
                          // customTextStyle:
                          //     (dom.Node node, TextStyle baseStyle) {
                          //   if (node is dom.Element) {
                          //     switch (node.localName) {
                          //       case "h1":
                          //         return baseStyle.merge(
                          //             Theme.of(context).textTheme.headline1);
                          //     }
                          //   }
                          //   return baseStyle;
                          // }
                          ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(color: const Color(0xFFE3E3E3), borderRadius: BorderRadius.circular(3)),
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Text(article.category!, style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.timer, color: Colors.black45, size: 12.0,),
                                  const SizedBox(width: 4,),
                                  Text(
                                    article.date!,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        article.video != ""
            ? Positioned(
          left: 18,
          top: 18,
          child: Card(
            color: Theme.of(context).accentColor,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.transparent,
              child: Image.asset("assets/play-button.png"),
            ),
            elevation: 18.0,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
          ),
        )
            : Container()
      ],
    ),
  );
}
