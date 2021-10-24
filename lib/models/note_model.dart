import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:note_app/entities/entities.dart';

class Note extends Equatable {
  final String? id;
  final String userId;
  final String content;
  final Color color;
  final DateTime timestamp;

  Note(
      {this.id,
      required this.userId,
      required this.content,
      required this.color,
      required this.timestamp});

  @override
  List<Object?> get props => [id, userId, content, color, timestamp];

  @override
  String toString() => '''Note {
    id: $id,
    userId: $userId,
    content: $content,
    color: $color,
    timestamp: $timestamp
  }''';

  NoteEntity toEntity() {
    return NoteEntity(
        id: id,
        userId: userId,
        content: content,
        color: '#${color.value.toRadixString(16)}',
        timestamp: Timestamp.fromDate(timestamp));
  }

  factory Note.fromEntity(NoteEntity noteEntity) {
    return Note(
        id: noteEntity.id,
        userId: noteEntity.userId,
        content: noteEntity.content,
        color: HexColor(noteEntity.color),
        timestamp: noteEntity.timestamp.toDate());
  }

  Note copy({
    String? id,
    String? userId,
    String? content,
    Color? color,
    DateTime? timestamp,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      color: color ?? this.color,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
