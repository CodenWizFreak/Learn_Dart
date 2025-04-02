import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HangmanGame(),
    );
  }
}

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final List<String> _words = ["flutter", "hangman", "dart", "programming", "developer"];
  String _chosenWord = "";
  List<String> _displayedWord = [];
  Set<String> _guessedLetters = {};
  int _incorrectGuesses = 0;
  final int _maxIncorrectGuesses = 6;
  bool _gameOver = false;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  // Start a new game
  void _startNewGame() {
    setState(() {
      _chosenWord = _words[Random().nextInt(_words.length)];
      _displayedWord = List.generate(_chosenWord.length, (index) => "_");
      _guessedLetters.clear();
      _incorrectGuesses = 0;
      _gameOver = false;
      _won = false;
    });
  }

  // Handle a letter guess
  void _guessLetter(String letter) {
    if (_gameOver || _guessedLetters.contains(letter)) {
      return;
    }
