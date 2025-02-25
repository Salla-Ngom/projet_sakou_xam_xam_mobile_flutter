import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ajouterQuiz(QuizModel quiz) async {
    await _firestore.collection('Quiz').doc(quiz.id).set(quiz.toMap());
  }
}
