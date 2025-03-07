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
