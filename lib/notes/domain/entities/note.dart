import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String text;
  final DateTime timestamp;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.text,
    required this.timestamp,
  });

  //Note to Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  //Json to Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  //update note
  Note updateNote({String? newTitle, String? newTex}) {
    return Note(
        id: id,
        userId: userId,
        title: newTitle ?? title,
        text: newTex ?? text,
        timestamp: timestamp);
  }
}
