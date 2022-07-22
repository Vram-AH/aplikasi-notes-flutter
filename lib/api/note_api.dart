import 'dart:convert';
import 'dart:io';

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
    // tambahakan try & catch untuk mengatasi error no internet/SocketException dan merubah tulisannya
    List<Note> notes = [];
    try {
      // tambahkan await agar kode dibawah menunggu proses get data selesai
      final response = await http.get(uri);

      print(response.statusCode);
      if (response.statusCode == 200) {
        // tambahkan validasi agar saat ambil data note kosong di firebase tidak error
        if (response.body == "null") return notes;
        // ubah data json menjadi map
        final results = json.decode(response.body) as Map<String, dynamic>;
        // looping map result ke List<Note>
        results.forEach((key, value) {
          notes.add(Note(
              id: key,
              title: value['title'],
              note: value['note'],
              isPinned: value['isPinned'],
              updatedAt: DateTime.parse(value['updated_at']),
              createdAt: DateTime.parse(value['created_at'])));
        });
      } else {
        throw Exception();
      }
    } on SocketException {
      throw SocketException('Tidak dapat tersambung ke internet');
    } catch (e) {
      throw Exception('Error terjadi kesalahan');
    }

    return notes;
  }

  // Buat fungsi note API untuk post note baru
  // tambahkan Future pada string dan async agar fungsi await bisa digunakan
  Future<String?> postNote(Note note) async {
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes.json');
    // buat map untuk isi/body yang akan dikirim ke server
    Map<String, dynamic> map = {
      'title': note.title,
      'note': note.note,
      'isPinned': note.isPinned,
      //1. karena encode akan mengubah data menjadi string json maka note.updatedAt dan note.createdAt di ubah menjadi string dengan toIso8601String
      //2. tambahkan validasi karena migrasi ke null agar tidak error
      'updated_at':
          note.updatedAt == null ? null : note.updatedAt!.toIso8601String(),
      'created_at':
          note.createdAt == null ? null : note.createdAt!.toIso8601String()
    };

    try {
      // ubah map jadi string json
      final body = json.encode(map);
      // 1. melakukan post
      // 2. tambahkan await agar kode dibawah menunggu proses get data selesai
      final response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        return json.decode(response.body)['name'];
      } else {
        throw Exception();
      }
    } on SocketException {
      throw SocketException('Tidak dapat tersambung ke internet');
    } catch (e) {
      throw Exception('Error, terjadi kesalahan');
    }
  }

  // tambahkan fungsi agar saat note diubah maka akan terupdate juga pada server
  Future<void> updateNote(Note note) async {
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes/${note.id}.json');
    Map<String, dynamic> map = {
      'title': note.title,
      'note': note.note,
      'updated_at': note.updatedAt!.toIso8601String(),
    };

    try {
      final body = json.encode(map);
      final response = await http.patch(uri, body: body);
      if (response.statusCode != 200) throw Exception();
    } on SocketException {
      throw SocketException('Tidak dapat tersambung ke internet');
    } catch (e) {
      throw Exception('Error, terjadi kesalahan');
    }
  }

  // tambahkan fungsi toggleIspined agar saat note di PIN maka terupdate pada server
  Future<void> toggleIsPinned(
      String? id, bool? isPinned, DateTime updatedAt) async {
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes/$id.json');
    Map<String, dynamic> map = {
      'isPinned': isPinned,
      'updated_at': updatedAt.toIso8601String(),
    };
    try {
      final body = json.encode(map);
      final response = await http.patch(uri, body: body);
      if (response.statusCode != 200) throw Exception();
    } on SocketException {
      throw SocketException('Tidak dapat tersambung ke internet');
    } catch (e) {
      throw Exception('Error, terjadi kesalahan');
    }
  }

  // fungsi untuk delete dan ubah atau kirim data tersebut ke server
  Future<void> deleteNote(String? id) async {
    final uri = Uri.parse(
        'https://notes-9f78d-default-rtdb.asia-southeast1.firebasedatabase.app/notes/$id.json');
    try {
      final response = await http.delete(uri);
      if (response.statusCode != 200) {
        throw Exception();
      }
    } on SocketException {
      throw SocketException('Tidak dapat tersambung ke internet');
    } catch (e) {
      throw Exception('Error, terjadi kesalahan');
    }
  }
}
