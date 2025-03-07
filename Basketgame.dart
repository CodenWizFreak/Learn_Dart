import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FallingObjectGame(),
      ),
    );
  }
}
class FallingObjectGame extends StatefulWidget {
  @override
  _FallingObjectGameState createState() => _FallingObjectGameState();
}

class _FallingObjectGameState extends State<FallingObjectGame> {
  double basketPosition = 0; // Horizontal position of the basket
  double basketWidth = 100;
  double basketHeight = 20;
  double objectWidth = 50;
  double objectHeight = 50;
  double fallingSpeed = 5; // Speed at which the object falls
  bool isGameOver = false;
  int score = 0;
  Timer? gameTimer;
  List<PositionedObject> fallingObjects = []; // List to store the positions of falling objects
// Start the game and update the falling objects and basket position
  void startGame() {
    gameTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (!isGameOver) {
        setState(() {
          // Update the position of each falling object
          for (var obj in List.from(fallingObjects)) { // Create a copy to avoid modifying while iterating
            obj.positionY += fallingSpeed;

            // Check for collision with the basket
            if (obj.positionY + objectHeight >= 600 - basketHeight &&
                obj.positionX + objectWidth > basketPosition &&
                obj.positionX < basketPosition + basketWidth) {
              score++;
              fallingObjects.remove(obj); // Remove object after it's caught
            }

            // Remove the object if it goes below the screen
            if (obj.positionY >= 600) {
              fallingObjects.remove(obj);
            }
          }
        });
      }
    });
  }
// Create a new falling object at a random position at the top
  void createFallingObject() {
    double randomX = Random().nextDouble() * (MediaQuery.of(context).size.width - objectWidth);
    setState(() {
      fallingObjects.add(PositionedObject(randomX, -objectHeight)); // Add object with initial Y off-screen
    });
  }

  // Handle horizontal movement of the basket using touch
  void moveBasket(DragUpdateDetails details) {
    setState(() {
      basketPosition += details.primaryDelta!;
      // Keep the basket within the screen boundaries
      if (basketPosition < 0) basketPosition = 0;
      if (basketPosition > MediaQuery.of(context).size.width - basketWidth)
      {
        basketPosition = MediaQuery.of(context).size.width - basketWidth;
      }
    });
  }
// Periodically create new falling objects
  void createObjectsPeriodically() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        createFallingObject();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
    createObjectsPeriodically();
  }

  @override
  void dispose() {
    super.dispose();
    gameTimer?.cancel();
  }
  
@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: isGameOver ? null : moveBasket,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.blue),
          ),
          // Basket (the player's catching object)
          Positioned(
            left: basketPosition,
            bottom: 0,
            child: Container(
              width: basketWidth,
              height: basketHeight,
              color: Colors.green,
            ),
          ),
          // Falling objects
          ...fallingObjects.map((obj) {
            return Positioned(
              left: obj.positionX,
              top: obj.positionY,
              child: Container(
                width: objectWidth,
                height: objectHeight,
                color: Colors.red,
              ),
            );
          }).toList(),
          // Game Over screen
          if (isGameOver)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Over',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isGameOver = false;
                        score = 0;
                        fallingObjects.clear();
                      });
                      startGame();
                    },
                    child: Text('Restart'),
                  ),
                ],
              ),
            ),
