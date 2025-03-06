import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGameApp());
}

class SnakeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  @override
    _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 20;
  static const double tileSize = 15.0;

  List<Offset> snake = [Offset(5, 5)];
  Offset food = Offset(10, 10);
  String direction = 'RIGHT';
  bool gameOver = false;
  int score = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
