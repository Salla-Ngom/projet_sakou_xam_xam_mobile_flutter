import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  final String status;
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;

  const ProfilPage({
    super.key,
    required this.status,
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
  });

  @override
  Widget build(BuildContext context) {
    String firstLetterOfNom = nom.isNotEmpty ? nom[0].toUpperCase() : '';
    String firstLetterOfPrenom = prenom.isNotEmpty ? prenom[0].toUpperCase() : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "👤 Profil $status",
            style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
            ),
           const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                '$firstLetterOfPrenom$firstLetterOfNom',
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            )],
            ),
           const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text(
              nom,
              style: const TextStyle(fontSize: 18),
            ),
          const  SizedBox(width: 10),
            Text(
              prenom,
              style: const TextStyle(fontSize: 18),
            ),
              ],
            ),
          _buildInfoRow("Nom",  nom),
          _buildInfoRow("Prénom", prenom),
          _buildInfoRow("Email", email),
          _buildInfoRow("Téléphone", telephone),
      const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Bouton rouge
              foregroundColor: Colors.white, // Texte blanc
            ),
            child:const Text("Modifier"),
          ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$label : ", style:const  TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

 