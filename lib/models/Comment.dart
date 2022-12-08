

class CommentSection {
  final int? id;
  final String? author;
  final String? avatar;
  final String? content;

  CommentSection({this.id, this.author, this.avatar, this.content});

  factory CommentSection.fromJson(Map<String, dynamic> json) {
    return CommentSection(
        id: json['id'],
        author: json['author_name'],
        avatar: json['author_avatar_urls']["48"],
        content: json["content"]["rendered"]);
  }
}
