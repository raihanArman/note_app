import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:note_app/blocs/blocs.dart';
import 'package:note_app/models/models.dart';
import 'package:note_app/repositories/notes/note_repository.dart';

part 'note_detail_event.dart';
part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final AuthBloc _authBloc;
  final NoteRepository _noteRepository;

  NoteDetailBloc(
      {required AuthBloc authBloc, required NoteRepository noteRepository})
      : _authBloc = authBloc,
        _noteRepository = noteRepository,
        super(NoteDetailState.empty());

  @override
  Stream<NoteDetailState> mapEventToState(NoteDetailEvent event) async* {
    if (event is NoteLoaded) {
      yield* _mapNoteLoadedToState(event);
    } else if (event is NoteContentUpdated) {
      yield* _mapNoteContentUpdatedToState(event);
    } else if (event is NoteColorUpdated) {
      yield* _mapNoteColorUpdatedToState(event);
    } else if (event is NoteAdded) {
      yield* _mapAddNoteToState();
    } else if (event is NoteSaved) {
      yield* _mapSaveNoteToState();
    } else if (event is NoteDeleted) {
      yield* _mapDeletedNoteToState();
    }
  }

  String _getCurrentUserId() {
    AuthState authState = _authBloc.state;
    late String currentUserId;
    if (authState is Anonymous) {
      currentUserId = authState.user.id;
    } else if (authState is Authenticated) {
      currentUserId = authState.user.id;
    }

    return currentUserId;
  }

  Stream<NoteDetailState> _mapNoteLoadedToState(NoteLoaded event) async* {
    yield state.update(note: event.note);
  }

  Stream<NoteDetailState> _mapNoteContentUpdatedToState(
      NoteContentUpdated event) async* {
    if (state.note == null) {
      final String currentUserId = _getCurrentUserId();
      final Note note = Note(
          userId: currentUserId,
          content: event.content,
          color: HexColor('#E74C3C'),
          timestamp: DateTime.now());
      yield state.update(note: note);
    } else {
      yield state.update(
          note: state.note!
              .copy(content: event.content, timestamp: DateTime.now()));
    }
  }

  Stream<NoteDetailState> _mapNoteColorUpdatedToState(
      NoteColorUpdated event) async* {
    if (state.note == null) {
      final String currentUserId = _getCurrentUserId();
      final Note note = Note(
          userId: currentUserId,
          content: '',
          color: event.color,
          timestamp: DateTime.now());
      yield state.update(note: note);
    } else {
      yield state.update(
          note:
              state.note!.copy(color: event.color, timestamp: DateTime.now()));
    }
  }

  Stream<NoteDetailState> _mapAddNoteToState() async* {
    yield NoteDetailState.submitting(note: state.note!);
    try {
      await _noteRepository.addNote(note: state.note!);
      yield NoteDetailState.success(note: state.note!);
    } catch (err) {
      yield NoteDetailState.failure(
          note: state.note!, errorMessage: 'New note couldnt not be added');
      yield state.update(
          isSubmitting: false,
          isSuccess: false,
          isFailure: false,
          errorMessage: '');
    }
  }

  Stream<NoteDetailState> _mapSaveNoteToState() async* {
    yield NoteDetailState.submitting(note: state.note!);
    try {
      await _noteRepository.updateNote(note: state.note!);
    } catch (err) {
      yield NoteDetailState.failure(
          note: state.note!, errorMessage: 'New note couldnt not be added');
      yield state.update(
          isSubmitting: false,
          isSuccess: false,
          isFailure: false,
          errorMessage: '');
    }
  }

  Stream<NoteDetailState> _mapDeletedNoteToState() async* {
    yield NoteDetailState.submitting(note: state.note!);
    try {
      await _noteRepository.deleteNote(note: state.note!);
    } catch (err) {
      yield NoteDetailState.failure(
          note: state.note!, errorMessage: 'Note couldnt not be delete');
      yield state.update(
          isSubmitting: false,
          isSuccess: false,
          isFailure: false,
          errorMessage: '');
    }
  }
}
