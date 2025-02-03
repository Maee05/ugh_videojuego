import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ugh_videojuego/menus/Gameover.dart';
import 'package:ugh_videojuego/objects/ground_block.dart';
import 'package:ugh_videojuego/players/EmberPlayer.dart';
import 'package:ugh_videojuego/players/Secondplayer.dart';

import '../components/Enemy.dart';
import '../components/GameTimer.dart';
import '../objects/Coin.dart';

class UghGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final world = World();
  late final CameraComponent cameraComponent;
  late EmberPlayer player;
  late Secondplayer player2;
  late ParallaxComponent parallax;
  late GameTimer gameTimer;
  bool isGameOver = false;
  int vivos = 2;

  @override
  Future<void> onLoad() async {
    // Pause the game when it starts
    pauseEngine();

    // Clear any existing overlays
    overlays.clear();

    // Load all necessary images
    await images.loadAll([
      "Dude_Monster.png",
      'Dude_Monster_Walk_6.png',
      "Dude_Monster_Jump_8.png",
      'Owlet_Monster_Walk_6.png',
      'fondo.png',
      'Pink_Monster_Walk_6.png',
      'Pink_Monster_Jump_8.png',
      'Owlet_Monster_Death_8.png',
      'Dude_Monster_Death_8.png',
      "Owlet_Monster_Jump_8.png",
      "Owlet_Monster.png",
      "cofre.png"

    ]);

    // Reset game state variables
    isGameOver = false;
    vivos = 2;

    // Initialize and add game timer
    gameTimer = GameTimer();
    add(gameTimer);

    // Load parallax background
    parallax = await ParallaxComponent.load(
      [ParallaxImageData('fondo.png')],
      baseVelocity: Vector2(70, 0),
    );
    add(parallax);



    // Load Tiled map
    final map = await TiledComponent.load('Mapa1.tmx', Vector2.all(32));
    map.position = Vector2.zero();
    map.priority = -1;

    // Setup camera
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor(0, 0);
    cameraComponent.viewfinder.zoom = 1.1;
    addAll([cameraComponent, world]);

    // Create players and enemy
    player = EmberPlayer(position: Vector2(100, 100));
    player2 = Secondplayer(position: Vector2(100, 100));
    final enemy = Enemy(position: Vector2(400, 100));

    // Add components to world
    world.add(player);
    world.add(player2);
    world.add(enemy);
    world.add(gameTimer);

    // Add ground blocks from Tiled map
    final colisionSuelos = map.tileMap.getLayer<ObjectGroup>('suelo');
    for (final suelos in colisionSuelos!.objects) {
      world.add(GroundBlock(
        position: Vector2(suelos.x, suelos.y),
        size: Vector2(suelos.width, suelos.height),
      ));
    }

    // Add map to world
    world.add(map);

    // Resume the game after setup
    resumeEngine();
  }

  void showGameOver() {
    if (!isGameOver) {
      isGameOver = true;
      pauseEngine(); // Stop all game updates
      overlays.add('gameover'); // Show game over overlay
    }
  }


  void _initializePlayers() {
    player = EmberPlayer(position: Vector2(100, 100));
    player2 = Secondplayer(position: Vector2(100, 100));
    world.add(player);
    world.add(player2);
  }

  void _initializeEnemies() {
    final enemy = Enemy(position: Vector2(400, 100));
    world.add(enemy);
  }

  void _loadMap() async {
    final map = await TiledComponent.load('Mapa1.tmx', Vector2.all(32));
    map.position = Vector2.zero();
    map.priority = -1;

// Cargar monedas desde la capa "coins"
    final coinLayer = map.tileMap.getLayer<ObjectGroup>('coins');
    if (coinLayer != null) {
      for (final coinObject in coinLayer.objects) {
        final coin = Coin(
          position: Vector2(coinObject.x, coinObject.y),
        );
        world.add(coin);
      }
    }

    // Add ground blocks
    final colisionSuelos = map.tileMap.getLayer<ObjectGroup>('suelo');
    for (final suelos in colisionSuelos!.objects) {
      world.add(GroundBlock(
        position: Vector2(suelos.x, suelos.y),
        size: Vector2(suelos.width, suelos.height),
      ));
    }

    world.add(map);
  }


}