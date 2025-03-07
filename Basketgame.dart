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
