import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

Widget commentBox(
    BuildContext context, String author, String avatar, String content) {
  return Card(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
      ),
      title: Html(
          data: content,
        style: {
          "p": Style(
            fontSize: const FontSize(20),
            //padding: const EdgeInsets.all(6),
            backgroundColor: Colors.black45,
          ),
        },
          // customTextStyle: (dom.Node node, TextStyle baseStyle) {
          //   if (node is dom.Element) {
          //     switch (node.localName) {
          //       case "p":
          //         return baseStyle.merge(Theme.of(context).textTheme.bodyText1);
          //     }
          //   }
          //   return baseStyle;
          // }
          ),
      subtitle: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Colors.black12),),
        ),
        child: Text(
          author,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ),
  );
}
