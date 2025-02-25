import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../gestionbloc/quiz_cubit.dart';
import '../../models/quiz_model.dart';

// 🟢 Fournit QuizCubit au reste de la page
class AjouterQuizPage extends StatelessWidget {
  const AjouterQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(),
      child: const AjouterQuizView(), // Affiche l'interface
    );
  }
}

// 🟢 Interface de la page
class AjouterQuizView extends StatefulWidget {
  const AjouterQuizView({super.key});

  @override
  State<AjouterQuizView> createState() => _AjouterQuizPageState();
}

class _AjouterQuizPageState extends State<AjouterQuizView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un Quiz"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Ajout d'un padding pour le défilement
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  controller: _titreController, label: "Titre du Quiz"),
              _buildTextField(
                  controller: _descriptionController, label: "Description"),
              const SizedBox(height: 20),
              BlocBuilder<QuizCubit, List<QuestionModel>>(
                builder: (context, questions) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: questions.length < 5
                            ? () => _ajouterQuestion(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              questions.length < 5 ? Colors.blue : Colors.grey,
                        ),
                        child: const Text("Ajouter une Question"),
                      ),
                      const SizedBox(height: 20),
                      if (questions.isNotEmpty)
                        Column(
                          children: List.generate(questions.length, (index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(
                                    "Question ${index + 1}: ${questions[index].question}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(3, (i) {
                                    return Text(
                                      "${i + 1}. ${questions[index].reponses[i]}",
                                      style: TextStyle(
                                        color: i ==
                                                questions[index]
                                                    .reponseCorrecteIndex
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    );
                                  }),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    context
                                        .read<QuizCubit>()
                                        .supprimerQuestion(index);
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _enregistrerQuiz(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Enregistrer le Quiz",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (value) => value!.isEmpty ? "Ce champ est requis" : null,
    );
  }

  void _ajouterQuestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // 🔹 Renommé pour éviter le conflit
        final questionController = TextEditingController();
        final List<TextEditingController> reponseControllers =
            List.generate(3, (index) => TextEditingController());
        int reponseCorrecteIndex = 0;

        return StatefulBuilder(
          builder: (dialogContext, setStateDialog) {
            // ✅ Utiliser dialogContext
            return AlertDialog(
              title: const Text("Ajouter une Question"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                        controller: questionController, label: "Question"),
                    const SizedBox(height: 10),
                    for (int i = 0; i < 3; i++)
                      Row(
                        children: [
                          Radio<int>(
                            value: i,
                            groupValue: reponseCorrecteIndex,
                            onChanged: (value) {
                              setStateDialog(() {
                                // ✅ Utiliser setStateDialog pour mettre à jour
                                reponseCorrecteIndex = value!;
                              });
                            },
                          ),
                          Expanded(
                              child: _buildTextField(
                                  controller: reponseControllers[i],
                                  label: "Réponse ${i + 1}")),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(
                      dialogContext), // ✅ Fermer avec dialogContext
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () {
                    if (questionController.text.isNotEmpty &&
                        reponseControllers.every((c) => c.text.isNotEmpty)) {
                      final question = QuestionModel(
                        question: questionController.text.trim(),
                        reponses: reponseControllers
                            .map((c) => c.text.trim())
                            .toList(),
                        reponseCorrecteIndex: reponseCorrecteIndex,
                      );

                      Navigator.of(dialogContext)
                          .pop(); // ✅ Fermer avant d'ajouter la question
                      context.read<QuizCubit>().ajouterQuestion(question);
                    }
                  },
                  child: const Text("Ajouter"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _enregistrerQuiz(BuildContext context) {
    if (_formKey.currentState!.validate() &&
        context.read<QuizCubit>().state.length == 5) {
      context.read<QuizCubit>().enregistrerQuiz(
            _titreController.text.trim(),
            _descriptionController.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quiz ajouté avec succès !")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Veuillez remplir tous les champs et ajouter 5 questions.")),
      );
    }
  }
}