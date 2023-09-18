
import 'package:isar/isar.dart';
import 'package:isar_example/model/author.dart';
import 'package:isar_example/model/book_category.dart';

part 'book.g.dart';

@Collection()
class Book {
  Id id = Isar.autoIncrement;
  late String title;
  late String isbn;
  late String description;
  final bookCategory = IsarLink<BookCategory>();
  final author = IsarLink<Author>();
}
