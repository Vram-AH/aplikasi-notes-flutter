import 'dart:convert';

import 'package:notes/models/note.dart';
import 'package:http/http.dart' as http;

// buat class yang berisi semua fungsi untuk koneksi ke server firebase
class NoteApi {
  // buat fungsi untuk mendapatkan seluruh note (list)
  // tambahkan Future dan async agar fungsi await bisa digunakan
  Future<List<Note>> getAllNote() async {
    // print('pertama dijalankan');
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes.json');
    // tambahkan await agar kode dibawah menunggu proses get data selesai
    final response = await http.get(uri);
    // print(response.body);
    // // // tambahkan .then agar dart mengeksekusi fungsi ini jika data future sudah benar2 selesai didapatkan
    // // response.then((value) {
    // //   print(value.body);
    // // });
    // print('ketiga dijalankan');

    // ubah data json menjadi map
    final results = json.decode(response.body) as Map<String, dynamic>;
    // looping map result ke List<Note>
    List<Note> notes = [];

    results.forEach((key, value) {
      notes.add(Note(
          id: key,
          title: value['title'],
          note: value['note'],
          isPinned: value['isPinned'],
          updatedAt: DateTime.parse(value['updated_at']),
          createdAt: DateTime.parse(value['created_at'])));
    });

    return notes;
  }

  // Buat fungsi note API untuk post note baru
  // tambahkan Future pada string dan async agar fungsi await bisa digunakan
  Future<String> postNote(Note note) async {
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes.json');
    // buat map untuk isi/body yang akan dikirim ke server
    Map<String, dynamic> map = {
      'title': note.title,
      'note': note.note,
      'isPinned': note.isPinned,
      // karena encode akan mengubah data menjadi string json maka note.updatedAt dan note.createdAt di ubah menjadi string dengan toIso8601String
      'updated_at': note.updatedAt.toIso8601String(),
      'created_at': note.createdAt.toIso8601String()
    };

    // ubah map jadi string json
    final body = json.encode(map);
    // 1. melakukan post
    // 2. tambahkan await agar kode dibawah menunggu proses get data selesai
    final response = await http.post(uri, body: body);

    return json.decode(response.body)['name'];
  }

  // tambahkan fungsi agar saat note diubah maka akan terupdate juga pada server
  Future<void> updateNote(Note note) async {
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes/${note.id}.json');
    Map<String, dynamic> map = {
      'title': note.title,
      'note': note.note,
      'updated_at': note.updatedAt.toIso8601String(),
    };

    final body = json.encode(map);
    final response = await http.patch(uri, body: body);
  }
}
