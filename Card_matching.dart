import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MemoryCardGame());
}

class MemoryCardGame extends StatefulWidget {
  @override
  _MemoryCardGameState createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> with TickerProviderStateMixin {
  // Expanded list of available emojis
  List<String> allEmojis = [
    '🍎', '🍌', '🍓', '🍍', '🍉', '🍒', '🍊', '🍓', '🍇', '🥭', '🍒', '🍑', '🥝', '🍋', '🍔', '🍕',
    '🍪', '🍩', '🍫', '🍿', '🍷', '🍺', '🍻', '🍴', '🥤', '🍲'
  ];

  // List of 12 emojis for the game, randomly selected pairs
  List<String> cards = [];
  List<String> revealedCards = List.filled(12, '');
  int flippedCount = 0;
  int matchCount = 0;
  int totalMatches = 6;
  int score = 0;  // Variable to keep track of the score
  List<int> flippedIndexes = [];  // Keep track of flipped card indexes

  // To control the flip animation for each card
  Map<int, AnimationController> flipControllers = {};

   @override
  void initState() {
    super.initState();
    // Create random pairs from the available emojis
    cards = _generateRandomCardList();
    cards.shuffle(Random());  // Shuffle the card list to randomize their positions
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    flipControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  // Generate random pairs of emojis
  List<String> _generateRandomCardList() {
    List<String> selectedEmojis = [];
    List<String> randomEmojis = List.from(allEmojis);

    // Select 6 unique emojis randomly and create pairs
    randomEmojis.shuffle(Random());
    for (int i = 0; i < 6; i++) {
      selectedEmojis.add(randomEmojis[i]);
      selectedEmojis.add(randomEmojis[i]);
    }

    return selectedEmojis;
  }

  // Card flip logic
  void onCardClick(int index) {
    if (revealedCards[index] != '' || flippedIndexes.length == 2) {
      return; // Card already flipped or two cards are already revealed
    }

    // Create an animation controller for this card flip
    flipControllers[index] = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this, // Use this as the TickerProvider
    );

    // Animate the card flip
    flipControllers[index]?.forward(from: 0);

    setState(() {
      revealedCards[index] = cards[index];
      flippedIndexes.add(index);
      flippedCount++;
    });

    // Increment score after every two cards turned
    if (flippedCount == 2) {
      setState(() {
        score++;  // Increment score
      });

      Future.delayed(Duration(milliseconds: 500), checkForMatch);
    }
  }

  // Check if two flipped cards match
  void checkForMatch() {
    int firstIndex = flippedIndexes[0];
    int secondIndex = flippedIndexes[1];

    if (revealedCards[firstIndex] == revealedCards[secondIndex]) {
      setState(() {
        matchCount++;
        if (matchCount == totalMatches) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Congratulations!"),
                content: Text("You matched all the pairs! Your score is $score"),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
} else {
      // Flip the cards back after a delay
      Future.delayed(Duration(seconds: 1), () {
        flipControllers[firstIndex]?.reverse();  // Flip back the first card
        flipControllers[secondIndex]?.reverse(); // Flip back the second card

        setState(() {
          revealedCards[firstIndex] = '';
          revealedCards[secondIndex] = '';
        });
      });
    }
// Reset flipped count and flippedIndexes
    setState(() {
      flippedCount = 0;
      flippedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Memory Card Game")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display the score
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // The grid of cards
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 columns of cards
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    // Create the animation for each card if it hasn't been created yet
                    if (flipControllers[index] == null) {
                      flipControllers[index] = AnimationController(
                        duration: Duration(milliseconds: 500),
                        vsync: this,
                      );
                    }

                    return GestureDetector(
                      onTap: () => onCardClick(index),
                      child: AnimatedBuilder(
                        animation: flipControllers[index]!,
                        builder: (context, child) {
                          final angle = flipControllers[index]!.value * pi;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(angle),
                            child: child,
                          );
                        },
                        child: Card(
                          key: ValueKey<int>(index),
                          color: Colors.blueAccent,
                          child: Center(
                            child: Stack(
                              children: [
                                // Back of the card (hidden side)
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ' ',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
