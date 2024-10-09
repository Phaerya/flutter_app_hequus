import 'package:flutter/material.dart';

class SavedGamesPage extends StatelessWidget {
  final List<Map<String, dynamic>> gameHistory; // Historique parties sauvés

  const SavedGamesPage({super.key, required this.gameHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique de parties"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff42A5F5), Color(0xff02569B)],
              stops: [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfffc00ff),
              Color(0xff00dbde),
            ],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: gameHistory.length,
          itemBuilder: (context, index) {
            final game = gameHistory[index];
            return ListTile(
              title: Text("Partie ${index + 1}: ${game['won']}"),
              subtitle:
                  Text("Essais: ${game['tries']}, Score: ${game['score']}"),
            );
          },
        ),
      ),
    );
  }
}
