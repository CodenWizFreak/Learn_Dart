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
