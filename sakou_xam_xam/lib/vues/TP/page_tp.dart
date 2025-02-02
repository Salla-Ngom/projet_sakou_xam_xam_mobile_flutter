import 'package:flutter/material.dart';
import '../../models/tp_model.dart';
import '../../services/tp_service.dart';
import 'fairetp.dart';

class ListeTPPage extends StatefulWidget {
  const ListeTPPage({super.key});

  @override
  State<ListeTPPage> createState() => _ListeTPPageState();
}

class _ListeTPPageState extends State<ListeTPPage> {
  final TPService _tpService = TPService();
  List<TPModel> _tpList = [];
  String _selectedMatiere = "Tous";

  @override
  void initState() {
    super.initState();
    _fetchTP();
  }

  Future<void> _fetchTP() async {
    List<TPModel> tp;
    if (_selectedMatiere == "Tous") {
      tp = await _tpService.getAllTP();
    } else {
      tp = await _tpService.getTPByMatiere(_selectedMatiere);
    }
    setState(() {
      _tpList = tp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des TP"),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMatiere = "chimie";
              });
              _fetchTP();
            },
            child: const Text("Chimie", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMatiere = "svt";
              });
              _fetchTP();
            },
            child: const Text("SVT", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMatiere = "Tous";
              });
              _fetchTP();
            },
            child: const Text("Tous", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _tpList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tpList.length,
              itemBuilder: (context, index) {
                TPModel tp = _tpList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text(tp.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(tp.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TPDetailPage(tp: tp),
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
