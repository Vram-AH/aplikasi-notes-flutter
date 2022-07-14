import 'package:notes/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // tambahkan variable static const untuk menghindari typo dan memudahkan merubah nama table
  static const TABLE_NOTES = 'notes';
  static const TABLE_NOTES_ID = 'id';
  static const TABLE_NOTES_NOTE = 'note';
  static const TABLE_NOTES_TITLE = 'title';
  static const TABLE_NOTES_ISPINNED = 'isPinned';
  static const TABLE_NOTES_UPDATEDAT = 'updated_at';
  static const TABLE_NOTES_CREATEDAT = 'created_at';

  // buat fungsi untuk open database
  static Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'notes.db'), version: 3,
        onCreate: (newDb, version) {
      newDb.execute('''
        CREATE TABLE $TABLE_NOTES (
          $TABLE_NOTES_ID TEXT PRIMARY KEY,
          $TABLE_NOTES_TITLE TEXT,
          $TABLE_NOTES_NOTE TEXT,
          $TABLE_NOTES_ISPINNED INTEGER,
          $TABLE_NOTES_UPDATEDAT TEXT,
          $TABLE_NOTES_CREATEDAT TEXT        
        )
          ''');
    },
        // fungsi untuk menambah table atau merubah nama colomn atau nama table (upgrade)
        onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion == 1 && newVersion == 2) {
        db.execute('''
        CREATE TABLE test_upgrade(
          id TEXT PRIMARY KEY,
          title TEXT
        )
        ''');
      }
      // test upgrade fungsi version 3
      if (oldVersion == 2 && newVersion == 3) {
        db.execute('''ALTER TABLE $TABLE_NOTES
        ADD COLUMN test_column_baru INTEGER DEFAULT 0        
        ''');
      }
    });
  }

  // buat fungsi untuk mendapatkan atau select note nya
  Future<List<Note>> getAllNote() async {
    final db = await DatabaseHelper.init();
    final result = await db.query('notes');

    List<Note> listNote = [];
    result.forEach((data) {
      listNote.add(Note.fromDb(data));
    });

    return listNote;
  }

  // buat fungsi untuk insert semua note
  Future<void> insertAllNote(List<Note> listNote) async {
    final db = await DatabaseHelper.init();
    // fungsi Batch untuk insert banyak data
    Batch batch = db.batch();

    listNote.forEach((note) {
      batch.insert(
        'notes',
        note.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit();
  }

  // fungsi untuk update data pada database helper
  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper.init();
    await db.update(TABLE_NOTES, note.toDb(),
        where: '$TABLE_NOTES_ID = ?', whereArgs: [note.id]);
  }

  // fungsi untuk update toogleIspinned pada database helper
  Future<void> toogleIspinned(
      String id, bool isPinned, DateTime updatedAt) async {
    final db = await DatabaseHelper.init();
    await db.update(
      TABLE_NOTES,
      {
        TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
        TABLE_NOTES_UPDATEDAT: updatedAt.toIso8601String(),
      },
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  // fungsi untuk update deleteNote pada database helper
  Future<void> deleteNote(String id) async {
    final db = await DatabaseHelper.init();
    await db.delete(TABLE_NOTES, where: '$TABLE_NOTES_ID = ?', whereArgs: [id]);
  }

  // fungsi untuk insert ke database saat tambah note baru
  Future<void> insertNote(Note note) async {
    final db = await DatabaseHelper.init();
    await db.insert(
      TABLE_NOTES,
      note.toDb(),
    );
  }
}
