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

