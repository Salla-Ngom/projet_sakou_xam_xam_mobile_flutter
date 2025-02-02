import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';
import '../../models/tp_model.dart';

class TPDetailPageTP extends StatefulWidget {
  final TPModel tp;

  const TPDetailPageTP({super.key, required this.tp});

  @override
  State<TPDetailPageTP> createState() => _TPDetailPageState();
}

class _TPDetailPageState extends State<TPDetailPageTP> {
  WebViewXController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tp.titre),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller?.reload();
            },
          ),
        ],
      ),
      body: WebViewX(
        key: const ValueKey('webviewx'),
        initialContent: widget.tp.chemin,
        initialSourceType: SourceType.url,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onWebViewCreated: (controller) {
          _controller = controller; // Pas de setState ici
        },
      ),
    );
  }
}
