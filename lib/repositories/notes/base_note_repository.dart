import 'package:note_app/models/models.dart';
import 'package:note_app/repositories/base_repository.dart';

abstract class BaseNoteRepository extends BaseRepository {
  Future<Note> addNote({required Note note});
  Future<Note> updateNote({required Note note});
  Future<Note> deleteNote({required Note note});
  Stream<List<Note>> streamNotes({required String userId});
}
