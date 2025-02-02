import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  final String id;
  final String titre;
  final String description;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.titre,
    required this.description,
    required this.questions,
  });

  // Convertir les données Firestore en objet Quiz
  factory Quiz.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Quiz(
      id: doc.id,
      titre: data['titre'],
      description: data['description'],
      questions: (data['questions'] as List)
          .map((q) => Question.fromMap(q))
          .toList(),
    );
  }

  // Convertir l'objet Quiz en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int bonneReponse; // Index de la bonne réponse

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.bonneReponse,
  });

  // Convertir une question Firestore en objet
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      id: data['id'],
      question: data['question'],
      options: List<String>.from(data['options']),
      bonneReponse: data['bonneReponse'],
    );
  }

  // Convertir une question en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'bonneReponse': bonneReponse,
    };
  }
}
