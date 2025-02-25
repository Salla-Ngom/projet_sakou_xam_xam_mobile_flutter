import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String titre;
  final String description;
  final List<QuestionModel> questions;

  QuizModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.questions,
  });

  /// 🔹 Convertir en `Map<String, dynamic>` pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  /// ✅ Correction de `fromDocument()` pour éviter les erreurs de conversion
  factory QuizModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Données du document invalides");
    }

    return QuizModel(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      questions: (data['questions'] != null && data['questions'] is List)
          ? (data['questions'] as List)
              .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

/// 📝 Modèle des Questions
class QuestionModel {
  final String question;
  final List<String> reponses;
  final int reponseCorrecteIndex;

  QuestionModel({
    required this.question,
    required this.reponses,
    required this.reponseCorrecteIndex,
  });

  /// 🔹 Convertir une question en `Map<String, dynamic>` pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'reponses': reponses,
      'reponseCorrecteIndex': reponseCorrecteIndex,
    };
  }

  /// ✅ Correction de `fromMap()` avec vérification
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      reponses: (map['reponses'] != null && map['reponses'] is List)
          ? List<String>.from(map['reponses'])
          : [],
      reponseCorrecteIndex: map['reponseCorrecteIndex'] ?? 0,
    );
  }
}
