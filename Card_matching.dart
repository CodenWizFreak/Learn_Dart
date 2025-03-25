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
