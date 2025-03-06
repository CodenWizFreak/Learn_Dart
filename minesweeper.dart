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

    // Calculate adjacent mine counts
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j].isMine) continue;
        int count = 0;
        for (int x = -1; x <= 1; x++) {
          for (int y = -1; y <= 1; y++) {
            int nx = i + x;
            int ny = j + y;
            if (nx >= 0 && ny >= 0 && nx < gridSize && ny < gridSize && grid[nx][ny].isMine) {
              count++;
            }
          }
        }
        grid[i][j].adjacentMines = count;
      }
    }

    setState(() {
      gameOver = false;
    });
  }
  void revealCell(int x, int y) {
    if (gameOver || revealed[x][y]) return;

    setState(() {
      revealed[x][y] = true;
    });

    if (grid[x][y].isMine) {
      setState(() {
        gameOver = true;
      });
    } else {
      if (grid[x][y].adjacentMines == 0) {
        // Reveal surrounding cells if no adjacent mines
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            int nx = x + dx;
            int ny = y + dy;
            if (nx >= 0 && ny >= 0 && nx < gridSize && ny < gridSize && !revealed[nx][ny]) {
              revealCell(nx, ny);
            }
          }
        }
      }
    }
  }
