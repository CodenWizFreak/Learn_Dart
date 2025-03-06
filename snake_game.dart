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
      case 'LEFT':
        newHead = Offset(newHead.dx - 1, newHead.dy);
        break;
      case 'RIGHT':
        newHead = Offset(newHead.dx + 1, newHead.dy);
        break;
    }

    // Wrap around the screen
    if (newHead.dx < 0) newHead = Offset(gridSize - 1, newHead.dy); // Wrap left to right
    if (newHead.dx >= gridSize) newHead = Offset(0, newHead.dy); // Wrap right to left
    if (newHead.dy < 0) newHead = Offset(newHead.dx, gridSize - 1); // Wrap top to bottom
    if (newHead.dy >= gridSize) newHead = Offset(newHead.dx, 0); // Wrap bottom to top

    // Check if snake eats the food
    if (newHead == food) {
      setState(() {
        score += 10; // Increase score by 10
      });
      snake.insert(0, newHead);
      generateFood();
      } else {
      snake.insert(0, newHead);
      snake.removeLast();
    }
  }

  void generateFood() {
    Random rand = Random();
    food = Offset(rand.nextInt(gridSize).toDouble(), rand.nextInt(gridSize).toDouble());
  }

  void checkCollision() {
    // Collision with itself
    for (int i = 1; i < snake.length; i++) {
      if (snake.first == snake[i]) {
        setState(() {
          gameOver = true;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display score
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < 0 && direction != 'DOWN') {
                  setState(() {
                    direction = 'UP';
                  });
