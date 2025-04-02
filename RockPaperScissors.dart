import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RockPaperScissorsGame(),
    );
  }
}

class RockPaperScissorsGame extends StatefulWidget {
  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  final List<String> choices = ['✊', '✋', '✌️'];
  String userChoice = '';
  String computerChoice = '';
  String result = '';

  void playGame(String userMove) {
    setState(() {
      userChoice = userMove;
      computerChoice = getComputerChoice();
      result = getResult(userChoice, computerChoice);
    });
  }

  String getComputerChoice() {
    Random random = Random();
    return choices[random.nextInt(3)];
  }

  String getResult(String userChoice, String computerChoice) {
    if (userChoice == computerChoice) {
      return 'It\'s a tie! 🤝';
    } else if ((userChoice == '✊' && computerChoice == '✌️') ||
               (userChoice == '✋' && computerChoice == '✊') ||
               (userChoice == '✌️' && computerChoice == '✋')) {
      return 'You win! 🎉';
    } else {
      return 'You lose! 😞';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose your move:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => playGame('✊'),
                  child: Text('✊', style: TextStyle(fontSize: 40)),
                ),
