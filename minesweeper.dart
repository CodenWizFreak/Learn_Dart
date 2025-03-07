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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minesweeper'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                resetGame();
                _animationController.reset();
                _animationController.repeat(reverse: true);
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Game title or status
          Text(
            gameOver ? 'Game Over' : 'Minesweeper',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Make the grid scrollable to prevent overflow
          Expanded(
            child: AnimatedBuilder(
              animation: _gridAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _gridAnimation.value,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      childAspectRatio: 1,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      int x = index ~/ gridSize;
                      int y = index % gridSize;
                      return GestureDetector(
                        onTap: () => revealCell(x, y),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: revealed[x][y] ? Colors.grey[300] : Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: revealed[x][y]
                                ? (grid[x][y].isMine
                                    ? Icon(Icons.dangerous, color: Colors.red)
                                    : grid[x][y].adjacentMines > 0
                                        ? Text(grid[x][y].adjacentMines.toString())
                                        : Container())
                                : Container(),
                            ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class Cell {
  final int x, y;
  bool isMine = false;
  int adjacentMines = 0;

  Cell(this.x, this.y);
}


