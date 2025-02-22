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

  /// Factory method pour convertir un document Firestore en `CoursModel`
  factory CoursModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CoursModel(
      id: doc.id,
      titre: data['titre'] ?? 'Sans titre',
      description: data['description'] ?? 'Aucune description',
      chemin: data['chemin'] ?? '',
      niveau: data['niveau'] ?? 'Inconnu',
      duree: data['duree'] ?? 'Inconnu',
      matiere: data['matiere'] ?? 'Inconnu',
    );
  }

  /// Convertir l'objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'chemin': chemin,
      'niveau': niveau,
      'duree': duree,
      'matiere': matiere,
    };
  }
}
