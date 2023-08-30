import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:touriso/models/comment.dart';
import 'package:touriso/utils/firebase_helper.dart';

class Article extends Equatable {
  final String? id;
  final String writerId;
  final DateTime dateTimePosted;
  final DateTime? lastEdited;
  final String title;
  final String content;
  final List<String> imageUrls;
  final List<String> siteIds;
  final List<String> activityIds;
  final List<String> views;
  final List<String> likes;
  final List<Comment> comments;

  const Article({
    this.id,required this.writerId,
    required this.dateTimePosted,
    this.lastEdited,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    this.siteIds = const [],
    this.activityIds = const [],
    this.views = const [],
    this.likes = const [],
    this.comments = const [],
  });

  Article.fromFirebase(Map<String, dynamic> map, String articleId)
      : id = articleId,
      writerId = map['writerId'],
        dateTimePosted = DateTime.fromMillisecondsSinceEpoch(
            (map['dateTimePosted'] as Timestamp).millisecondsSinceEpoch),
        lastEdited = map['lastEdited'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                (map['lastEdited'] as Timestamp).millisecondsSinceEpoch),
        title = map['title'],
        content = map['content'],
        imageUrls =
            (map['imageUrls'] as List).map((e) => e.toString()).toList(),
        siteIds = (map['siteIds'] as List).map((e) => e.toString()).toList(),
        activityIds =
            (map['activityIds'] as List).map((e) => e.toString()).toList(),
        views = (map['views'] as List).map((e) => e.toString()).toList(),
        likes = (map['likes'] as List).map((e) => e.toString()).toList(),
        comments = (map['comments'] as List)
            .map((e) => Comment.fromFirebase(e))
            .toList();

  Map<String, dynamic> toMap() => {
        'writerId': uid,
        'dateTimePosted': dateTimePosted,
        'lastEdited': lastEdited,
        'title': title,
        'content': content,
        'imageUrls': imageUrls,
        'siteIds': siteIds,
        'activityIds': activityIds,
        'views': views,
        'likes': likes,
        'comments': comments,
      };

  @override
  List<Object?> get props => [
        id,
        writerId,
        dateTimePosted,
        lastEdited,
        title,
        content,
        imageUrls,
        siteIds,
        activityIds,
        views,
        likes,
        comments,
      ];
}
