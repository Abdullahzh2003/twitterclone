import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class post {
  String? postId; // UUID for post
  List<comment>? Listofcomment;
  List<String>? LikeList;
  int? likecount;
  String? userid;
  Timestamp? Date;
  String? media;
  String? content;

  post(
      {this.LikeList,
      this.Listofcomment,
      this.likecount,
      this.content,
      this.media,
      this.userid}) {
    // Generate UUID v4 for post
    postId = const Uuid().v4();
    Date = Timestamp.now();
  }
}

class comment {
  String? userid;
  String? Date;
  String? content;
  comment({this.Date, this.content, this.userid});
}
