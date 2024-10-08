class Game {
  final String hiddenCard = 'assets/images/ab67706c0000d72c1f63b6282c73c8d789880bad.png';

  List<String>? gameImg;

  final List<String> cards_list = [
    "assets/images/heart.png",
    "assets/images/triangle.png",
    "assets/images/star.png",
    "assets/images/circle.png",
    "assets/images/triangle.png",
    "assets/images/circle.png",
    "assets/images/heart.png",
    "assets/images/star.png",
    "assets/images/circle.png",
    "assets/images/triangle.png",
    "assets/images/heart.png",
    "assets/images/star.png",
    "assets/images/triangle.png",
    "assets/images/heart.png",
    "assets/images/circle.png",
    "assets/images/star.png"
  ];

  List<Map<int, String>> matchCheck = [];

  final int cardCount = 16;

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCard);
  }
}
