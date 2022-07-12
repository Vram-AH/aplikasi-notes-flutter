import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:notes/api/note_api.dart';
import 'package:notes/models/note.dart';

class Notes with ChangeNotifier {
  List<Note> _notes = [
    Note(
      id: 'N1',
      title: 'Catatan Materi Flutter',
      note:
          'Flutter merupakan Software Development Kit (SDK) yang bisa membantu developer dalam membuat aplikasi mobile cross platform. Kelas ini akan mempelajari pengembangan aplikasi mobile yang dapat dijalankan baik di IOS maupun di Android',
      updatedAt: DateTime.parse('2021-05-19 20:33:33'),
      createdAt: DateTime.parse('2021-05-19 20:33:33'),
    ),
    Note(
      id: 'N2',
      title: 'Target Pembelajaran Flutter',
      note:
          'Peserta dapat mengembangkan aplikasi mobile (IOS dan Android) menggunakan flutter,\nPeserta memahami konsep pengembangan aplikasi menggunakan flutter,\nPeserta dapat menjalankan aplikasi mobile di IOS dan Android ataupun Emulator,\nPeserta memahami bahasa pemrograman Dart,\nPeserta dapat mendevelop aplikasi mobile menggunakan flutter dan dart dari dasar secara berurutan.',
      updatedAt: DateTime.parse('2021-05-20 20:53:33'),
      createdAt: DateTime.parse('2021-05-20 20:53:33'),
    ),
    Note(
      id: 'N3',
      title: 'Belajar Flutter di ITBOX',
      note: 'Jangan lupa belajar flutter dengan video interactive di ITBOX.',
      updatedAt: DateTime.parse('2021-05-20 21:22:33'),
      createdAt: DateTime.parse('2021-05-20 21:22:33'),
    ),
    Note(
      id: 'N4',
      title: 'Resep nasi goreng',
      note:
          'Nasi putih 1 piring\nBawang putih 2 siung, cincang halus\nKecap manis atau kecap asin sesuai selera\nSaus sambal sesuai selera\nSaus tiram sesuai selera\nGaram secukupnya\nKaldu bubuk rasa ayam atau sapi sesuai selera\nDaun bawang 1 batang, cincang halus\nTelur ayam 1 butir\nSosis ayam 1 buah, iris tipis\nMargarin atau minyak goreng 3 sdm.',
      updatedAt: DateTime.parse('2021-05-20 21:51:33'),
      createdAt: DateTime.parse('2021-05-20 21:51:33'),
    ),
  ];

  Future<void> getAndSetNotes() async {
    // tambahkan fungsi try & catch untuk mengatasi error
    try {
      _notes = await NoteApi().getAllNote();
    } on SocketException {
      notifyListeners();
      return;
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  List<Note> get notes {
// mengurutkan note ( yang di pin ditampilkan lebih dahulu)
    List<Note> tempListNote = _notes.where((note) => note.isPinned).toList();
    tempListNote.addAll(_notes.where((note) => !note.isPinned).toList());
    return tempListNote;
  }

// menambahkan toggleIsPinned untuk merubah isPinned yang true ke false dan sebaliknya
  Future<void> toggleIsPinned(String id) async {
    // menampung atau mencari note dengan id yang sama
    int index = notes.indexWhere((note) => note.id == id);
    try {
      // melakukan validasi
      if (index >= 0) {
        _notes[index].isPinned = !_notes[index].isPinned;
        // ganti tanggal update pada server
        _notes[index] = _notes[index].copyWith(updatedAt: DateTime.now());
        // tambahkan notifier untuk memberi tau widget yang listen ke provider bahwa data sudah berubah
        notifyListeners();
        // panggil fungsi toggleIsPinned pada API sebelum notifyListeners

        await NoteApi().toggleIsPinned(
            id, _notes[index].isPinned, _notes[index].updatedAt);
      }
    } catch (e) {
      _notes[index].isPinned = !_notes[index].isPinned;
      notifyListeners();
      return Future.error(e);
    }
  }

// 1. fungsi addNote untuk menambahkan note ke provider
  Future<void> addNote(Note note) async {
    try {
      // 2. panggil fungsi postNote dan tambahkan await, future dan async
      // 3. tampung return id dari API dengan membuat String id:
      String id = await NoteApi().postNote(note);
      // 4. sebelum tambahkan notes ke dalam _notes buat note.copyWith(id: id saat kita post)
      note = note.copyWith(id: id);
      _notes.add(note);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Note getNote(String id) {
    return _notes.firstWhere((note) => note.id == id);
  }

  // Fungsi untuk update
  Future<void> updateNote(Note newNote) async {
    try {
      // sebelum updateNote ke dalam listnote panggil dulu fungsi NoteApi
      await NoteApi().updateNote(newNote);
      int index = _notes.indexWhere((note) => note.id == newNote.id);
      _notes[index] = newNote;
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  // fungsi untuk delete note ketika di swap kiri atau kanan
  Future<void> deleteNote(String id) async {
    // tambahkan fungsi agar pada saat error apa yang sudah di remove dibalikkan lagi
    int index = _notes.indexWhere((note) => note.id == id);
    Note tempNote = _notes[index];
    try {
      _notes.removeAt(index);
      // _notes.removeWhere((note) => note.id == id);
      notifyListeners();
      // panggil fungsi delete pada note.api
      await NoteApi().deleteNote(id);
    } catch (e) {
      _notes.insert(index, tempNote);
      notifyListeners();
      return Future.error(e);
    }
  }
}
