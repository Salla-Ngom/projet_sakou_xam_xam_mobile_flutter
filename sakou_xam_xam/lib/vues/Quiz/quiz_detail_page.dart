import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';

class QuizDetailPage extends StatefulWidget {
  final Quiz quiz;
  const QuizDetailPage({super.key, required this.quiz});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  int _currentQuestionIndex = 0;
  final List<int?> _selectedAnswers = List.filled(10, null);
  int _score = 0;

  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] == widget.quiz.questions[_currentQuestionIndex].bonneReponse) {
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

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Résultat"),
        content: Text("Votre score est $_score / 10"),
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
    Question question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${_currentQuestionIndex + 1} / 10",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              question.question,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Column(
              children: List.generate(
                question.options.length,
                (index) => RadioListTile<int>(
                  title: Text(question.options[index]),
                  value: index,
                  groupValue: _selectedAnswers[_currentQuestionIndex],
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswers[_currentQuestionIndex] = value;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedAnswers[_currentQuestionIndex] == null ? null : _nextQuestion,
              child: Text(_currentQuestionIndex == widget.quiz.questions.length - 1 ? "Terminer" : "Suivant"),
            ),
          ],
        ),
      ),
    );
  }
}
