import 'dart:math' as math show pi;
import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            leading: Transform.scale(
              scale: 1.2,
              child: Transform.rotate(
                angle: 270 * math.pi / 180,
                child: const Icon(
                  Icons.note,
                ),
              ),
            ),
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: Transform.scale(
                scale: 0.8,
                child: const Icon(
                  Icons.delete,
                  color: Colors.amber,
                ),
              ),
            ),
            onTap: () {
              onTap(note);
            },
          );
        });
  }
}
