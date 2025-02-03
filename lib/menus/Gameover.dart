import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ugh_videojuego/games/UghGame.dart';

class Gameover extends StatelessWidget {
  final UghGame game;
  final VoidCallback onRestart;

  const Gameover({
    super.key,
    required this.game,
    required this.onRestart
  });

  @override
  Widget build(BuildContext context) {
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: const LinearGradient(
              colors: [Color(0xFF5D3FD3), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GAME OVER',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onRestart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Reiniciar Juego'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameRestartWidget extends StatefulWidget {
  const GameRestartWidget({super.key});

  @override
  _GameRestartWidgetState createState() => _GameRestartWidgetState();
}

class _GameRestartWidgetState extends State<GameRestartWidget> {
  Key _gameKey = UniqueKey();

  void restartGame() {
    setState(() {
      _gameKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<UghGame>.controlled(
      key: _gameKey,
      gameFactory: UghGame.new,
      overlayBuilderMap: {
        'gameover': (_, game) => Gameover(
          game: game,
          onRestart: restartGame,
        ),
      },
    );
  }
}