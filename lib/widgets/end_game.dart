import 'package:flutter/material.dart';

void showEndGameDialog(BuildContext context, String title, String content, Function onRestart) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRestart();
            },
            child: const Text("Rejouer"),
          ),
        ],
      );
    },
  );
}
