import 'package:flutter/material.dart';
import 'package:notes/providers/notes.dart';
import 'package:notes/screens/add_or_detail_screen.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Gunakan note provider ke main => bungkus MaterialApp dengan changeNotifierProvider dan jangan lupa import packagenya
    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: HomeScreen(),
        routes: {
          AddOrDetailScreen.routeName: (ctx) => AddOrDetailScreen(),
        },
      ),
    );
  }
}
