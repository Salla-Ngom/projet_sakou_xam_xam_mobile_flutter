import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/quiz_model.dart';
import 'quiz_detail_page.dart'; // Page pour créer un quiz

class QuizListPage extends StatelessWidget {
  const QuizListPage({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference quizzes = FirebaseFirestore.instance.collection('Quiz');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Quiz"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizzes.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("❌ Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.red)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("📭 Aucun quiz disponible.", style: TextStyle(fontSize: 16)),
            );
          }

          List<QuizModel> quizList = snapshot.data!.docs
              .map((doc) => QuizModel.fromDocument(doc)) // ✅ Correction ici
              .toList();

          return ListView.separated(
            itemCount: quizList.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              QuizModel quiz = quizList[index];
              return Card(
                key: ValueKey(quiz.id),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  title: Text(
                    quiz.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    quiz.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
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
