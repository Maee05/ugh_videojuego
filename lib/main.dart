import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ugh_videojuego/menus/Gameover.dart';
import 'games/UghGame.dart';

void main() {
  runApp(
    GameWidget<UghGame>.controlled(
      gameFactory: UghGame.new,
      overlayBuilderMap: {
        'gameover': (_, game) => Gameover(game: game),
        },
      ),
  );
}