import 'package:flutter/material.dart';
import 'widgets/score_board.dart';
import 'widgets/game_logic.dart';
import 'widgets/flip_card.dart';
import 'widgets/end_game.dart';

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
    // Check for end of game conditions
    if (tries >= 20) {
      showEndGameDialog(
          context, "Perdu !", "Vous avez atteint 30 essais !", _restartGame);
    } else if (_game.gameImg!.every((image) => image != _game.hiddenCard)) {
      showEndGameDialog(context, "Gagné !",
          "Vous avez débloqué toutes les cartes !", _restartGame);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffca1e27),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "JEU DE MEMOIRE",
              style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              scoreBoard("Essais", "$tries"),
              scoreBoard("Score", "$score")
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
                        _game.matchCheck.add({index: _game.cards_list[index]});
                        _game.gameImg![index] = _game.cards_list[index];
                      });

                      if (_game.matchCheck.length == 2) {
                        if (_game.matchCheck[0].values.first ==
                            _game.matchCheck[1].values.first) {
                          print(true);
                          score += 100;
                          _game.matchCheck.clear();
                        } else {
                          print(false);
                          Future.delayed(const Duration(milliseconds: 750), () {
                            setState(() {
                              _game.gameImg![_game.matchCheck[0].keys.first] =
                                  _game.hiddenCard;
                              _game.gameImg![_game.matchCheck[1].keys.first] =
                                  _game.hiddenCard;
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
    );
  }
}
