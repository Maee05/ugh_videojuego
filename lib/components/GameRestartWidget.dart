
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../games/UghGame.dart';
import '../menus/Gameover.dart';

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