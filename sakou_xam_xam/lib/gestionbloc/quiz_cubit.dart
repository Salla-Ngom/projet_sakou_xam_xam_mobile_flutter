import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class QuizCubit extends Cubit<List<QuestionModel>> {
  QuizCubit() : super([]);

  void ajouterQuestion(QuestionModel question) {
    if (state.length < 5) {
      emit([...state, question]);
    }
  }

  void supprimerQuestion(int index) {
    final List<QuestionModel> updatedQuestions = List.from(state);
    updatedQuestions.removeAt(index);
    emit(updatedQuestions);
  }

  Future<void> enregistrerQuiz(String titre, String description) async {
    if (state.length == 5) {
      final quiz = QuizModel(
        id: FirebaseFirestore.instance.collection('Quiz').doc().id,
        titre: titre,
        description: description,
        questions: state,
      );

      await QuizService().ajouterQuiz(quiz);
    }
  }
}
