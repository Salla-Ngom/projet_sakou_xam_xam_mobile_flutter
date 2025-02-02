import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/quiz_model.dart';
import 'quiz_detail_page.dart';

class QuizListPage extends StatelessWidget {
  const QuizListPage({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference quizzes = FirebaseFirestore.instance.collection('quizzes');

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Quiz")),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizzes.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun quiz disponible."));
          }

          var quizList = snapshot.data!.docs.map((doc) => Quiz.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: quizList.length,
            itemBuilder: (context, index) {
              Quiz quiz = quizList[index];
              return Card(
                child: ListTile(
                  title: Text(quiz.titre),
                  subtitle: Text(quiz.description),
                  trailing: const Icon(Icons.play_arrow, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizDetailPage(quiz: quiz)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
