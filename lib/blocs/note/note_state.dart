part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;

  const NoteLoaded({required this.notes});

  @override
  List<Object> get props => [notes];

  @override
  String toString() => 'NotesLoaded {notes : $notes}';
}

class NoteError extends NoteState {}
