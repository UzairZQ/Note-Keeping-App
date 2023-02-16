import 'package:hive_database/models/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box('notes');
}
