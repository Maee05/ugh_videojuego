import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ugh_videojuego/games/UghGame.dart';

class Gameover extends StatelessWidget {
  // Referencia al juego principal.
  final UghGame game;

  const Gameover({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: 400,
          width: 600,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            // Gradiente que va de un púrpura profundo a negro
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
              // Título "Fin" con sombra y mayor énfasis
              Text(
                'GAME OVER',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 40,
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
              // Botón de "Restart" para reiniciar el juego

            ],
          ),
        ),
      ),
    );
  }
}
