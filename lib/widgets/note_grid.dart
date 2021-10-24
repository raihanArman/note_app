import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/models.dart';

class NoteGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onTap;

  const NoteGrid({Key? key, required this.notes, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 40),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final Note note = notes[index];
          return _buildNote(note);
        }, childCount: notes.length),
      ),
    );
  }

  _buildNote(Note note) {
    return GestureDetector(
      onTap: () => onTap(note),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  note.content,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                DateFormat.yMd().add_jm().format(note.timestamp),
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        color: Colors.orange,
      ),
    );
  }
}
