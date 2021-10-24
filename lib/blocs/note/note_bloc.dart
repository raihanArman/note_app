import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/blocs/blocs.dart';
import 'package:note_app/models/models.dart';
import 'package:note_app/repositories/repositoties.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final AuthRepository _authRepository;
  final NoteRepository _noteRepository;
  StreamSubscription? _notesSubscription;

  NoteBloc(
      {required AuthRepository authRepository,
      required NoteRepository noteRepository})
      : _authRepository = authRepository,
        _noteRepository = noteRepository,
        super(NoteInitial());

  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is FetchNotes) {
      yield* _mapFetchNotesToState();
    } else if (event is UpdateNotes) {
      yield* _mapUpdateNotesToState(event);
    }
  }

  Stream<NoteState> _mapFetchNotesToState() async* {
    yield NoteLoading();
    try {
      final User? currentUser = await _authRepository.getCurrentUser();
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository
          .streamNotes(userId: currentUser!.id)
          .listen((notes) => add(UpdateNotes(notes: notes)));
    } catch (err) {
      print(err);
      yield NoteError();
    }
  }

  Stream<NoteState> _mapUpdateNotesToState(UpdateNotes event) async* {
    yield NoteLoaded(notes: event.notes);
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
