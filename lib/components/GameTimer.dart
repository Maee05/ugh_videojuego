import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ugh_videojuego/games/UghGame.dart';

class GameTimer extends TextComponent with HasGameReference<UghGame> {
  GameTimer() : super(
    position: Vector2(0, 30),
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: 48,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black54,
            offset: Offset(2, 2),
          ),
        ],
      ),
    ),
  );

  double _timeLeft = 20.0;
  bool _isFinished = false;

  @override
  void onMount() {
    super.onMount();
    position.x = game.size.x / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isFinished) {
      _timeLeft -= dt;
      if (_timeLeft <= 11) {
        textRenderer = TextPaint(
          style: TextStyle(
            fontSize: 56,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.red.withOpacity(0.7),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        );
      }
      if (_timeLeft <= 6) {
        textRenderer = TextPaint(
          style: TextStyle(
            fontSize: 60,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.red.withOpacity(0.7),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        );
      }

      if (_timeLeft <= 1) {
        _timeLeft = 0;
        _isFinished = true;
        game.showGameOver();
      }

      text = 'Tiempo: ${_timeLeft.toInt()}';
    }
  }
}