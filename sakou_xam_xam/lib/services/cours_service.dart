import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cours.dart';

class CoursService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<CoursModel>> getAllCours() async {
    QuerySnapshot snapshot = await _firestore.collection('Cours').get();
    return snapshot.docs.map((doc) => CoursModel.fromDocument(doc)).toList();
  }
  Future<List<CoursModel>> getCoursByMatiere(String matiere) async {
    QuerySnapshot snapshot =
        await _firestore.collection('Cours').where('matiere', isEqualTo: matiere).get();
    return snapshot.docs.map((doc) => CoursModel.fromDocument(doc)).toList();
  }
}
