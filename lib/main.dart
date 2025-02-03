import 'package:flutter/material.dart';
import 'package:ugh_videojuego/components/GameRestartWidget.dart';

void main() {
  runApp(MaterialApp(
    home: GameRestartWidget(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}