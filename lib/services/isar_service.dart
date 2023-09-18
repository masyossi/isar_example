import 'package:isar/isar.dart';
import 'package:isar_example/model/author.dart';
import 'package:isar_example/model/book.dart';
import 'package:isar_example/model/book_category.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationSupportDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [BookSchema, BookCategorySchema, AuthorSchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> createBook(Book newBook) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.books.putSync(newBook));
  }

  Future<void> createBookCategory(BookCategory newBookCategory) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.bookCategorys.putSync(newBookCategory));
  }

  Future<void> createAuthor(Author newAuthor) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.authors.putSync(newAuthor));
  }

  Stream<List<BookCategory>> getAllBookCategories() async* {
    final isar = await db;
    yield* isar.bookCategorys.where().watch(fireImmediately: true);
  }

  Stream<List<Book>> getAllBooks({String? search}) async* {
    print(search);
    final isar = await db;
    final query = isar.books
        .where()
        .filter()
        .titleContains(search ?? '', caseSensitive: false)
        .build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      }
    }
  }

  Stream<List<Author>> getAllAuthors() async* {
    final isar = await db;
    yield* isar.authors.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }
}
