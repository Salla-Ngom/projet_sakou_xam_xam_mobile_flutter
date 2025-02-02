import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final String telephone;
  final Timestamp createdAt;
  final String role;
  final bool actif;

  User ({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.createdAt,
    required this.role,
    required this.actif,
  });

  // Convertir un UserModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'createdAt': createdAt,
      'role': role,
      'actif': actif,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      prenom: data['prenom'] ?? '',
      nom: data['nom'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      role: data['role'] ?? 'eleve',
      actif: data['actif'] ?? true,
    );
  }
}
