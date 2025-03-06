import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MinesweeperApp());
}

class MinesweeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MinesweeperGame(),
    );
  }
}
class MinesweeperGame extends StatefulWidget {
  @override
  _MinesweeperGameState createState() => _MinesweeperGameState();
}

class _MinesweeperGameState extends State<MinesweeperGame> with TickerProviderStateMixin {
  static const int gridSize = 8;
  static const int totalMines = 10;
  late List<List<Cell>> grid;
  late List<List<bool>> revealed;
  bool gameOver = false;
  late AnimationController _animationController;
  late Animation<double> _gridAnimation;

  @override
  void initState() {
    super.initState();
    resetGame();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _gridAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  void resetGame() {
    grid = List.generate(gridSize, (i) => List.generate(gridSize, (j) => Cell(i, j)));
    revealed = List.generate(gridSize, (i) => List.generate(gridSize, (j) => false));

    // Place mines
    Random random = Random();
    int minesPlaced = 0;
    while (minesPlaced < totalMines) {
      int x = random.nextInt(gridSize);
      int y = random.nextInt(gridSize);
      if (!grid[x][y].isMine) {
        grid[x][y].isMine = true;
        minesPlaced++;
      }
    }
