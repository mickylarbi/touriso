import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String userId;
  final String content;

  const Comment({required this.userId, required this.content});

  Comment.fromFirebase(Map<String, dynamic> map)
      : userId = map['userId'],
        content = map['content'];

  Map<String, dynamic> toMap() => {'userId': userId, 'content': content};

  @override
  List<Object?> get props => [userId, content];
}
