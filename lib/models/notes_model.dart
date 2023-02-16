import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 1)
class NotesModel extends HiveObject {
  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  NotesModel({required this.description, required this.title});
}
