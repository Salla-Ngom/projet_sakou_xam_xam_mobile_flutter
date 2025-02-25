import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../gestionbloc/admin_cubit.dart';
import '../Connexion/login.dart';
import 'Cours/liste_cours.dart';
import 'TP/page_tp.dart';
import 'Quiz/quiz_list_page.dart';
import 'Quiz/ajout_quiz.dart';
import 'profil.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../services/cours_service.dart';

class AdminPage extends StatelessWidget {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;

  const AdminPage({
    super.key,
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
  });

  void _deconnecterUtilisateur(BuildContext context) {
    showDialog(
      context: context, // Utilisation du contexte passé en paramètre
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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

  final String status = "Administrateur";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(),
      child: BlocBuilder<AdminCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            appBar: AppBar(
              title: Text("$nom $prenom"),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person,
                                    color: Colors.blue),
                                title: const Text('Profil'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilPage(
                                              status: status,
                                              id: id,
                                              nom: nom,
                                              prenom: prenom,
                                              email: email,
                                              telephone: telephone,
                                            )),
                                  );
                                },
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.logout, color: Colors.red),
                                title: const Text('Déconnexion'),
                                onTap: () => _deconnecterUtilisateur(
                                    context), // Passage du contexte ici
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            body: IndexedStack(
              index: currentIndex,
              children: [
            const _HomePage(),
                _CoursPage(),
                _TPPage(),
                _UtilisateursPage(),
                _QuizPage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType
                  .fixed, // ✅ Empêche l'animation entre les onglets
              backgroundColor: Colors.white, // ✅ Fond blanc
              selectedItemColor: Colors.blue, // ✅ Onglet actif en bleu
              unselectedItemColor: Colors.grey, // ✅ Onglets inactifs en gris
              showSelectedLabels:
                  true, // ✅ Affiche les labels des onglets sélectionnés
              showUnselectedLabels:
                  true, // ✅ Affiche les labels des onglets non sélectionnés
              onTap: (index) => context.read<AdminCubit>().changePage(index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: "Cours"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.science), label: "TPs"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: "Users"),
                BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quizz"),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 🏡 Page d'accueil (Statistiques)

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int totalCours = 0;
  int totalTPs = 0;
  int totalQuiz = 0;
  int totalUsers = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Récupérer les données depuis Firestore
      QuerySnapshot coursSnapshot = await firestore.collection('Cours').get();
      QuerySnapshot tpSnapshot = await firestore.collection('Tps').get();
      QuerySnapshot quizSnapshot = await firestore.collection('Quiz').get();
      QuerySnapshot usersSnapshot = await firestore.collection('users').get();

      setState(() {
        totalCours = coursSnapshot.size;
        totalTPs = tpSnapshot.size;
        totalQuiz = quizSnapshot.size;
        totalUsers = usersSnapshot.size;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 150,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              "$count",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Fond légèrement coloré
      appBar: AppBar(
        title: const Text("📊 Tableau de bord"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Statistiques du système",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildStatCard("Cours", totalCours, Icons.book, Colors.blue),
                        _buildStatCard("TPs", totalTPs, Icons.science, Colors.green),
                        _buildStatCard("Quiz", totalQuiz, Icons.quiz, Colors.orange),
                        _buildStatCard("Utilisateurs", totalUsers, Icons.people, Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


/// 📚 Page des Cours
class _CoursPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: ListeCoursPage(), // Liste des cours
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Naviguer vers la page d'ajout de cours
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AjouterCoursPage()),
              );
            },
            child: const Text("Ajouter un nouveau cours"),
          ),
        ),
      ],
    );
  }
}

/// 🧪 Page des TPs
class _TPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: ListeTPPage(), // Liste des cours
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Naviguer vers la page d'ajout de cours
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AjouterCoursPage()),
              );
            },
            child: const Text("Ajouter un nouveau TP"),
          ),
        ),
      ],
    );
  }
}

/// 👥 Page des Utilisateurs

class _UtilisateursPage extends StatefulWidget {
  @override
  State<_UtilisateursPage> createState() => _UtilisateursPageState();
}

class _UtilisateursPageState extends State<_UtilisateursPage> {
  String _selectedRole = "eleve"; // Par défaut, on affiche les élèves

  Future<void> _toggleActivation(String userId, bool currentStatus) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "actif": !currentStatus,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              currentStatus ? "Utilisateur désactivé" : "Utilisateur activé"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👥 Gestion des utilisateurs"),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedRole = "eleve";
              });
            },
            child: const Text("Élèves", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedRole = "Admin";
              });
            },
            child: const Text("Admins", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: _selectedRole)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text("${user['prenom']} ${user['nom']}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user['email']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _toggleActivation(user.id, user['actif']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          user['actif'] ? Colors.red : Colors.green,
                    ),
                    child: Text(user['actif'] ? "Désactiver" : "Activer"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// 📝 Page du Profil
class _QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: QuizListPage(), // Liste des cours
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Naviguer vers la page d'ajout de cours
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AjouterQuizPage()),
              );
            },
            child: const Text("Ajouter un nouveau Quizz"),
          ),
        ),
      ],
    );
  }
}

/// Page pour ajouter un nouveau cours

class AjouterCoursPage extends StatefulWidget {
  const AjouterCoursPage({super.key});
  @override
  State<AjouterCoursPage> createState() => _AjouterCoursPageState();
}

class _AjouterCoursPageState extends State<AjouterCoursPage> {
  final CoursService _coursService = CoursService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _niveauController = TextEditingController();
  final TextEditingController _dureeController = TextEditingController();

  String _selectedMatiere = "chimie"; // Valeur par défaut
  File? _selectedFile;
  bool _isLoading = false;

  /// **Choisir un fichier PDF**
  Future<void> _choisirFichier() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!); // Conversion PlatformFile -> File
      });
    }
  }

  /// **Ajouter un cours dans Firestore et uploader le PDF**
  Future<void> _ajouterCours() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir un fichier PDF")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String pdfUrl = await _coursService.uploadPDF(_selectedFile!);

      Map<String, dynamic> coursData = {
        'titre': _titreController.text.trim(),
        'description': _descriptionController.text.trim(),
        'chemin': pdfUrl,
        'niveau': _niveauController.text.trim(),
        'duree': _dureeController.text.trim(),
        'matiere': _selectedMatiere,
      };

      await _coursService.ajouterCours(coursData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cours ajouté avec succès !")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: $e")),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Cours"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_titreController, "Titre"),
              _buildTextField(_descriptionController, "Description", maxLines: 3),
              _buildTextField(_niveauController, "Niveau"),
              _buildTextField(_dureeController, "Durée"),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedMatiere,
                items: const [
                  DropdownMenuItem(value: "chimie", child: Text("Chimie")),
                  DropdownMenuItem(value: "svt", child: Text("SVT")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMatiere = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Matière"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _choisirFichier,
                    child: const Text("Choisir un PDF"),
                  ),
                  const SizedBox(width: 10),
                  _selectedFile != null
                      ? Text(_selectedFile!.path.split('/').last)
                      : const Text("Aucun fichier sélectionné"),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _ajouterCours,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? "Ce champ est requis" : null,
    );
  }
}