import 'package:flutter/material.dart';
import 'package:notes/presentations/custom_icon_icons.dart';
import 'package:notes/providers/notes.dart';
import 'package:notes/screens/add_or_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NoteItem extends StatefulWidget {
  final String id;
  NoteItem({
    @required this.id,
  });
  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    //fungsi untuk mengakses provider
    final notesProvider = Provider.of<Notes>(context, listen: false);
    Note note = notesProvider.getNote(widget.id);
    //wrap dengan GestureDetector untuk menavigasi note ke addOrDetailScreen
    // wrap GestureDetector dengan Dismissible agar note bisa dihapus
    return Dismissible(
      key: Key(note.id),
      onDismissed: (direction) {
        notesProvider.deleteNote(note.id);
      },
      child: GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed(AddOrDetailScreen.routeName,
                // add arguments untuk memberikan id note ke addOrDetailScreen
                arguments: note.id),
        child: GridTile(
          header: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                notesProvider.toogleIspinned(note.id);
              },
              icon: Icon(
                note.isPinned ? CustomIcon.pin : CustomIcon.pin_outline,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[800]),
            child: Text(note.note),
            padding: EdgeInsets.all(12),
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(note.title),
            ),
          ),
        ),
      ),
    );
  }
}
