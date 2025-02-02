import 'package:cloud_firestore/cloud_firestore.dart';

class CoursModel {
  final String id;
  final String titre;
  final String description;
  final String chemin;
  final String niveau;
  final String duree;
  final String matiere;

  CoursModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.chemin,
    required this.niveau,
    required this.duree,
    required this.matiere,
  });

  // Convertir un CoursModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'chemin': chemin,
      'niveau': niveau,
      'duree': duree,
      'matiere': matiere,
    };
  }

  // Créer un CoursModel à partir d'un document Firestore
  factory CoursModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CoursModel(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      chemin: data['chemin'] ?? '',
      niveau: data['niveau'] ?? '',
      duree: data['duree'] ?? '',
      matiere: data['matiere'] ?? '',
    );
  }
}
