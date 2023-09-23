import 'package:flutter/material.dart';

class newNoteView extends StatefulWidget {
  const newNoteView({super.key});

  @override
  State<newNoteView> createState() => _newNoteViewState();
}

class _newNoteViewState extends State<newNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: const Text('Write Your Note here'),
    );
  }
}
