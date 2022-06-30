import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes.dart';
import 'package:notes/screens/add_or_detail_screen.dart';
import 'package:notes/widgets/notes_grid.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      // wrap dengan FutureBuilder karena data butuh waktu untuk didapatkan
      body: FutureBuilder(
        future: Provider.of<Notes>(context, listen: false).getAndSetNotes(),
        builder: (ctx, notesSnapshot) {
          if (notesSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          return NotesGrid();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddOrDetailScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      // body: Column(
      //   children: [
      //     ..._lisNote.map(
      //       (note) => Container(
      //         child: Text(note.note),
      //         padding: EdgeInsets.all(12),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
