part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class FetchNotes extends NoteEvent {}

class UpdateNotes extends NoteEvent {
  final List<Note> notes;

  const UpdateNotes({required this.notes});

  @override
  List<Object> get props => [notes];

  @override
  String toString() => 'Updatenotes {notes : $notes}';
}
