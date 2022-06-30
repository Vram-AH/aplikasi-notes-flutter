import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes.dart';
import 'package:notes/widgets/note_item.dart';
import 'package:provider/provider.dart';

class NotesGrid extends StatefulWidget {
  @override
  State<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends State<NotesGrid> {
  @override
  Widget build(BuildContext context) {
    // gunakan data provider
    final notesProvider = Provider.of<Notes>(context);
    List<Note> listNote = notesProvider.notes;
    return Padding(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: listNote.length,
        itemBuilder: (ctx, index) => NoteItem(
          id: listNote[index].id,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
      ),
    );
  }
}
