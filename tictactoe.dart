import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}
class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.generate(9, (index) => ''); // Tic Tac Toe grid
  bool isPlayerXTurn = true; // Player starts as 'X'
  bool gameOver = false;
  String winner = '';

  // Function to handle player move
  void playerMove(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = 'X'; // Player makes a move
        checkWinner();
        if (!gameOver) {
          computerMove(); // If game isn't over, let the computer play
        }
      });
    }
  }
  // Function for computer move
  void computerMove() {
    if (gameOver) return;

    // Generate a random available spot for the computer to play 'O'
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') availableMoves.add(i);
    }

    if (availableMoves.isNotEmpty) {
      int move = availableMoves[Random().nextInt(availableMoves.length)];

      setState(() {
        board[move] = 'O'; // Computer makes a move
        checkWinner();
      });
    }
  }

  // Check for a winner
  void checkWinner() {
    // Winning combinations
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]] &&
          board[combination[0]] != '') {
        setState(() {
          gameOver = true;
          winner = board[combination[0]]; // Set winner (X or O)
        });
        return;
      }
    }
    // Check for draw
    if (!board.contains('') && !gameOver) {
      setState(() {
        gameOver = true;
        winner = 'Draw';
      });
    }
  }

  // Restart the game
  void restartGame() {
    setState(() {
      board = List.generate(9, (index) => ''); // Reset board
      isPlayerXTurn = true;
      gameOver = false;
      winner = '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe - Player vs Computer'),
      ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Player X vs Computer O',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Displaying the grid
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),

