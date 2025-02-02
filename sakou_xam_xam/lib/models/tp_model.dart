import 'package:cloud_firestore/cloud_firestore.dart';

class TPModel {
  final String id;
  final String titre;
  final String description;
  final String matiere;
  final String chemin;

  TPModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.matiere,
    required this.chemin,
  });

  // Convertir un TPModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'matiere': matiere,
      'chemin': chemin,
    };
  }

  // Créer un TPModel à partir d'un document Firestore
  factory TPModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TPModel(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      matiere: data['matiere'] ?? '',
      chemin: data['chemin'] ?? '',
    );
  }
}
