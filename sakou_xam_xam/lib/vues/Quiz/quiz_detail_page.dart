import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';

class QuizDetailPage extends StatefulWidget {
  final QuizModel quiz;

  const QuizDetailPage({super.key, required this.quiz});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  int _currentQuestionIndex = 0;
  final List<int?> _selectedAnswers = List.filled(10, null);
  int _score = 0;

  /// Fonction pour passer à la question suivante
  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] == widget.quiz.questions[_currentQuestionIndex].reponseCorrecteIndex) {
      _score++;
    }
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  /// Fonction pour afficher le résultat final
  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche la fermeture du dialogue par un clic en dehors
      builder: (context) => AlertDialog(
        title: const Text("🎯 Résultat du Quiz"),
        content: Text("✅ Votre score est : $_score / ${widget.quiz.questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    QuestionModel question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔵 Barre de progression
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 8,
            ),
            const SizedBox(height: 20),

            /// 🔢 Numéro de la question
            Text(
              "Question ${_currentQuestionIndex + 1} / ${widget.quiz.questions.length}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),

            /// ❓ Affichage de la question
            Text(
              question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            /// 📌 Affichage des réponses en boutons radio
            Column(
              children: List.generate(
                question.reponses.length,
                (index) => RadioListTile<int>(
                  title: Text(question.reponses[index]),
                  value: index,
                  groupValue: _selectedAnswers[_currentQuestionIndex],
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswers[_currentQuestionIndex] = value;
                    });
                  },
                ),
              ),
            ),

            const Spacer(),

            /// ➡️ Bouton "Suivant" ou "Terminer"
            ElevatedButton(
              onPressed: _selectedAnswers[_currentQuestionIndex] == null ? null : _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _currentQuestionIndex == widget.quiz.questions.length - 1 ? "🎉 Terminer" : "➡️ Suivant",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
