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

    setState(() {
      _guessedLetters.add(letter);

      if (_chosenWord.contains(letter)) {
        // Update the displayed word with the correct letter
        for (int i = 0; i < _chosenWord.length; i++) {
          if (_chosenWord[i] == letter) {
            _displayedWord[i] = letter;
          }
        }
      } else {
        _incorrectGuesses++;
      }

      // Check if the game is over
      if (_incorrectGuesses >= _maxIncorrectGuesses) {
        _gameOver = true;
      }

      // Check if the player won
      if (!_displayedWord.contains("_")) {
        _won = true;
        _gameOver = true;
      }
    });
  }
  // Build the UI for the game
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // Make the body scrollable
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display Hangman drawing as text
            HangmanDrawing(incorrectGuesses: _incorrectGuesses),

            SizedBox(height: 30),

            // Display the word with underscores for unguessed letters
            Text(
              _displayedWord.join(" "),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            
            // Display the guessed letters
            Text(
              "Guessed Letters: ${_guessedLetters.join(", ")}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Display the number of incorrect guesses
            Text(
              "Incorrect Guesses: $_incorrectGuesses / $_maxIncorrectGuesses",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Display game over/win message
            if (_gameOver)
              Text(
                _won ? "You won!" : "Game Over! The word was: $_chosenWord",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _won ? Colors.green : Colors.red),
              ),
            SizedBox(height: 20),
            // Display the alphabet to guess letters
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(26, (index) {
                String letter = String.fromCharCode(index + 97);  // 'a' to 'z'
                return ElevatedButton(
                  onPressed: _gameOver || _guessedLetters.contains(letter) ? null : () => _guessLetter(letter),
                  child: Text(letter.toUpperCase(), style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                    backgroundColor: Colors.teal, // Button color
                  ),
                );
              }),
            ),
            SizedBox(height: 20),

            // Start a new game button
            ElevatedButton(
              onPressed: _startNewGame,
              child: Text("Start New Game", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Hangman drawing widget with text
class HangmanDrawing extends StatelessWidget {
  final int incorrectGuesses;

  HangmanDrawing({required this.incorrectGuesses});

  @override
  Widget build(BuildContext context) {
    String hangman = '';
    
    switch (incorrectGuesses) {
      case 0:
        hangman = '  \n  \n  \n  \n  \n  \n';
        break;
      case 1:
        hangman = '  \n  \n  \n  \n  \n /';
        break;
      case 2:
        hangman = '  \n  \n  \n  \n /|\\ \n /';
        break;
      case 3:
        hangman = '  \n  \n  \n  |  \n /|\\ \n /';
        break;
        case 4:
        hangman = '  \n  | \n  | \n /|\\ \n /';
        break;
      case 5:
        hangman = '  |  \n  |  \n  |  \n /|\\ \n /';
        break;
      case 6:
        hangman = '  |  \n  |  \n  |  \n /|\\ \n / \\';
        break;
      default:
        hangman = '  \n  \n  \n  \n  \n  \n';
    }

    return Column(
      children: [
        Text(
          hangman,
          style: TextStyle(fontFamily: 'Courier', fontSize: 24, color: Colors.black),
        ),
      ],
    );
  }
}
