import 'package:flutter/material.dart';
import 'widgets/score_board.dart';
import 'widgets/game_logic.dart';
import 'widgets/flip_card.dart';
import 'widgets/end_game.dart';
import 'widgets/game_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Game _game = Game();
  int tries = 0;
  int score = 0;
  List<Map<String, dynamic>> gameHistory = [];

  @override
  void initState() {
    super.initState();
    _game.matchCheck.clear();
    _game.initGame();
  }

  void _restartGame() {
    setState(() {
      tries = 0;
      score = 0;
      _game.matchCheck.clear();
      _game.initGame();
    });
  }
  void _checkEndGame() {
    bool won = false;
    String resultMessage;

    bool allCardsRevealed =
    _game.gameImg!.every((image) => image != _game.hiddenCard);

    if (tries >= 25) {
      resultMessage = "Vous avez atteint 25 essais, vous avez perdu.";
      showEndGameDialog(context, "Perdu !", resultMessage, _restartGame);

      gameHistory.add({
        'tries': tries,
        'score': score,
        'won': 'Perdu',
      });

    } else if (allCardsRevealed) {
      won = true;
      resultMessage = "Félicitations ! Vous avez débloqué toutes les cartes.";
      showEndGameDialog(context, "Gagné !", resultMessage, _restartGame);

      // Ajouter à l'historique quand la partie est gagnée
      gameHistory.add({
        'tries': tries,
        'score': score,
        'won': 'Gagné',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Jeu de Mémoire"),
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
          actions: [
            IconButton(
              icon: const Icon(Icons.history, size: 36.0),
              onPressed: () {
                // Parties sauvegardées, on passe gameHistory en paramètre pour alimenter la liste
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SavedGamesPage(gameHistory: gameHistory),
                  ),
                );
              },
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff05386b),
                Color(0xff5cdb95),
              ],
              stops: [0, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  scoreBoard("Essais", "$tries"),
                  scoreBoard("Score", "$score"),
                ],
              ),
              SizedBox(
                height: screen_width,
                width: screen_width,
                child: GridView.builder(
                  itemCount: _game.gameImg!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (_game.gameImg![index] == _game.hiddenCard) {
                          print(_game.cards_list[index]);
                          setState(() {
                            tries++;
                            _game.matchCheck
                                .add({index: _game.cards_list[index]});
                            _game.gameImg![index] = _game.cards_list[index];
                          });

                          if (_game.matchCheck.length == 2) {
                            if (_game.matchCheck[0].values.first ==
                                _game.matchCheck[1].values.first) {
                              print(true);
                              score += 100;
                              tries -= 2;
                              _game.matchCheck.clear();
                            } else {
                              print(false);
                              Future.delayed(const Duration(milliseconds: 750),
                                  () {
                                setState(() {
                                  _game.gameImg![_game.matchCheck[0].keys
                                      .first] = _game.hiddenCard;
                                  _game.gameImg![_game.matchCheck[1].keys
                                      .first] = _game.hiddenCard;
                                  _game.matchCheck.clear();
                                });
                              });
                            }
                          }
                          _checkEndGame();
                        }
                      },
                      child: FlipCard(
                        frontImage: _game.gameImg![index],
                        backImage: _game.hiddenCard,
                        isFlipped: _game.gameImg![index] != _game.hiddenCard,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
