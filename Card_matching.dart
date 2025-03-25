import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MemoryCardGame());
}

class MemoryCardGame extends StatefulWidget {
  @override
  _MemoryCardGameState createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> with TickerProviderStateMixin {
  // Expanded list of available emojis
  List<String> allEmojis = [
    '🍎', '🍌', '🍓', '🍍', '🍉', '🍒', '🍊', '🍓', '🍇', '🥭', '🍒', '🍑', '🥝', '🍋', '🍔', '🍕',
    '🍪', '🍩', '🍫', '🍿', '🍷', '🍺', '🍻', '🍴', '🥤', '🍲'
  ];
