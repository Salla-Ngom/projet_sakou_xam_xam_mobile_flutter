import 'package:flutter/material.dart';
import 'Cours/liste_cours.dart';
import 'TP/page_tp.dart';
import 'Quiz/quiz_list_page.dart';
import 'profil.dart';
import '../Connexion/login.dart';

class HomePage extends StatefulWidget {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  const HomePage(
      {super.key,
      required this.id,
      required this.nom,
      required this.prenom,
      required this.email,
      required this.telephone});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final String status= "Éleve";
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      ElevetHomePage(userIdC: widget.id),
      const ListeCoursPage(),
      const ListeTPPage(),
      const QuizListPage(),
    ];
  }

  void _deconnecterUtilisateur() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   LoginPage()),
                );

              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, Bonjour ${widget.prenom}"),
        centerTitle: true, // Centrer le texte
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: const Text('Profil'),
                        onTap: () {
                          Navigator.pop(context); 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   ProfilPage(
                                    status:status,
                            id: widget.id,
                            nom: widget.nom,
                            prenom: widget.prenom,
                            email: widget.email,
                            telephone: widget.telephone,
                          )), 
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Déconnexion'),
                        onTap: _deconnecterUtilisateur,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

      body: _pages[_currentIndex], // Affiche la page en fonction de l'index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'TP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quizz',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class ElevetHomePage extends StatelessWidget {
  final String userIdC;

  const ElevetHomePage({super.key, required this.userIdC});

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
