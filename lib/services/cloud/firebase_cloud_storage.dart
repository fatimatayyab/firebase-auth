import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testproject/services/cloud/cloud_note.dart';
import 'package:testproject/services/cloud/cloud_storage_constants.dart';
import 'package:testproject/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudNote.fromSnapshot(doc))
      );
    return allNotes;
  }

//delete Note
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  // Update Note
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Creating New  Note
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // CREATING SINGELTON //
  //Factory Constructor talking with static final field which inturns calls private constructor
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  //Private Constructor
  FirebaseCloudStorage._sharedInstance();
  //Factory Constructor
  factory FirebaseCloudStorage() => _shared;
}
