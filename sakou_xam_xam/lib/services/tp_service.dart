import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tp_model.dart';

class TPService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer tous les TP
  Future<List<TPModel>> getAllTP() async {
    QuerySnapshot snapshot = await _firestore.collection('Tps').get();
    return snapshot.docs.map((doc) => TPModel.fromDocument(doc)).toList();
  }

  // Récupérer les TP par matière (chimie ou svt)
  Future<List<TPModel>> getTPByMatiere(String matiere) async {
    QuerySnapshot snapshot =
        await _firestore.collection('Tps').where('matiere', isEqualTo: matiere).get();
    return snapshot.docs.map((doc) => TPModel.fromDocument(doc)).toList();
  }
}
