import 'package:flutter/material.dart';
import '../../models/cours.dart';
import '../../services/cours_service.dart';
import 'detail_cours.dart';

class ListeCoursPage extends StatefulWidget {
  const ListeCoursPage({super.key});

  @override
  State<ListeCoursPage> createState() => _ListeCoursPageState();
}

class _ListeCoursPageState extends State<ListeCoursPage> {
  final CoursService _coursService = CoursService();
  List<CoursModel> _cours = [];
  String _selectedMatiere = "Tous";

  @override
  void initState() {
    super.initState();
    _fetchCours();
  }

  Future<void> _fetchCours() async {
    List<CoursModel> cours;
    if (_selectedMatiere == "Tous") {
      cours = await _coursService.getAllCours();
    } else {
      cours = await _coursService.getCoursByMatiere(_selectedMatiere);
    }
    setState(() {
      _cours = cours;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Cours"),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMatiere = "chimie";
              });
              _fetchCours();
            },
            child: const Text("Chimie", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMatiere = "svt";
              });
              _fetchCours();
            },
            child: const Text("SVT", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMatiere = "Tous";
              });
              _fetchCours();
            },
            child: const Text("Tous", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _cours.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cours.length,
              itemBuilder: (context, index) {
                CoursModel cours = _cours[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text(cours.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Durée : ${cours.duree}"),
                        Text("Niveau : ${cours.niveau}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursDetailPage(cours: cours),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
