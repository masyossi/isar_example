import 'package:isar/isar.dart';
import 'package:isar_example/model/book.dart';

part 'author.g.dart';

@Collection()
class Author {
  Id id = Isar.autoIncrement;

  late String firstName;

  late String lastName;

  final books = IsarLinks<Book>();
}
