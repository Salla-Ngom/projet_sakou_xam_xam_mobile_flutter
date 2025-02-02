import 'package:flutter/material.dart';
import '../../models/cours.dart';

class CoursDetailPage extends StatelessWidget {
  final CoursModel cours;

  const CoursDetailPage({super.key, required this.cours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cours.titre),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cours.titre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Durée : ${cours.duree}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Niveau : ${cours.niveau}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              cours.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
          
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Accéder au cours"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
