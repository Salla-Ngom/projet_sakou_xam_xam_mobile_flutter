import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cours.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CoursService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Récupérer tous les cours
  Future<List<CoursModel>> getAllCours() async {
    QuerySnapshot snapshot = await _firestore.collection('Cours').get();
    return snapshot.docs.map((doc) => CoursModel.fromDocument(doc)).toList();
  }

  /// Récupérer les cours par matière (chimie ou SVT)
  Future<List<CoursModel>> getCoursByMatiere(String matiere) async {
    QuerySnapshot snapshot = await _firestore
        .collection('Cours')
        .where('matiere', isEqualTo: matiere)
        .get();
    return snapshot.docs.map((doc) => CoursModel.fromDocument(doc)).toList();
  }

  /// Ajouter un cours dans Firestore
  Future<void> ajouterCours(Map<String, dynamic> coursData) async {
    await _firestore.collection('Cours').add(coursData);
  }

  /// Supprimer un cours par son ID
  Future<void> supprimerCours(String coursId) async {
    await _firestore.collection('Cours').doc(coursId).delete();
  }

  /// Uploader un fichier PDF vers Firebase Storage
  Future<String> uploadPDF(File file) async {
    try {
      // Créer une référence vers le fichier dans Firebase Storage
      Reference storageReference = _storage
          .ref()
          .child('cours_pdf/${DateTime.now().millisecondsSinceEpoch}.pdf');

      // Uploader le fichier
      UploadTask uploadTask = storageReference.putFile(file);

      // Attendre la fin de l'upload
      TaskSnapshot taskSnapshot = await uploadTask;

      // Récupérer l'URL du fichier uploadé
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      throw Exception("Erreur lors de l'upload du fichier : $e");
    }
  }
}