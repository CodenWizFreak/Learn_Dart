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
    score = 0;
    gameOver = false;
    snake = [Offset(5, 5)];
    direction = 'RIGHT';
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (gameOver) {
        timer.cancel();
      } else {
        moveSnake();
        checkCollision();
        setState(() {});
      }
    });
  }

  void moveSnake() {
    Offset newHead = snake.first;
    switch (direction) {
      case 'UP':
        newHead = Offset(newHead.dx, newHead.dy - 1);
        break;
      case 'DOWN':
        newHead = Offset(newHead.dx, newHead.dy + 1);
        break;
