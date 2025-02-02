import 'package:flutter/material.dart';
import '../../models/tp_model.dart';
import 'tp.dart';

class TPDetailPage extends StatelessWidget {
  final TPModel tp;

  const TPDetailPage({super.key, required this.tp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tp.titre),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tp.titre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Matière : ${tp.matiere}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              tp.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TPDetailPageTP(tp: tp),
                  ),);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Accéder au TP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
