import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes.dart';
import 'package:provider/provider.dart';

class AddOrDetailScreen extends StatefulWidget {
  static const routeName = '/addOrDetailScreen';
  @override
  State<AddOrDetailScreen> createState() => _AddOrDetailScreenState();
}

class _AddOrDetailScreenState extends State<AddOrDetailScreen> {
  Note _note = Note(
    id: null,
    title: '',
    note: '',
    updatedAt: null,
    createdAt: null,
  );

  bool init = true;

  final _formKey = GlobalKey<FormState>();

  void submitNote() {
    _formKey.currentState.save();
    final now = DateTime.now();
    _note = _note.copyWith(updatedAt: now, createdAt: now);
    final notesProvider = Provider.of<Notes>(context, listen: false);
    if (_note.id == null) {
      notesProvider.addNote(_note);
    } else {
      notesProvider.updateNote(_note);
    }
    notesProvider.addNote(_note);
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      String id = ModalRoute.of(context).settings.arguments as String;
      _note = Provider.of<Notes>(context).getNote(id);
      init = false;
    }

    super.didChangeDependencies();
  }

  // fungsi untuk merubah format waktu di detail note
  String _convertDate(DateTime dateTime) {
    int diff = DateTime.now().difference(dateTime).inDays;
    if (diff > 0) return DateFormat('dd-MM-yyyy').format(dateTime);

    return DateFormat('hh-mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: submitNote,
            child: Text('Simpan'),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(12),
            // wrap dengan SingleChildScrollView agar bisa di scroll
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        // tambahkan initialValue agar saat note ditekan memunculkan judul
                        initialValue: _note.title,
                        decoration: InputDecoration(
                            hintText: 'Judul', border: InputBorder.none),
                        onSaved: (value) {
                          _note = _note.copyWith(title: value);
                        },
                      ),
                      TextFormField(
                        // tambahkan initialValue agar saat note ditekan memunculkan isi note
                        initialValue: _note.note,
                        decoration: InputDecoration(
                            hintText: 'Tulis Catatan Disini...',
                            border: InputBorder.none),
                        onSaved: (value) {
                          _note = _note.copyWith(note: value);
                        },
                        // tambahkan maxLines untuk menampilkan note tulisan ke bawah
                        maxLines: null,
                      ),
                    ],
                  )),
            ),
          ),
          // Untuk menampilkan kapan note terakhir diubah
          // wrap dengan Positioned agar update waktu pindah ke bawah
          Positioned(
              bottom: 10,
              right: 10,
              child: Text('Terakhir diubah ${_convertDate(_note.updatedAt)}'))
        ],
      ),
    );
  }
}