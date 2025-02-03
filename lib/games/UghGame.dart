import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ugh_videojuego/objects/ground_block.dart';
import 'package:ugh_videojuego/players/EmberPlayer.dart';
import 'package:ugh_videojuego/players/Secondplayer.dart';

import '../components/Enemy.dart';

class UghGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final world = World();
  late final CameraComponent cameraComponent;
  late EmberPlayer player;
  late Secondplayer player2;
  late ParallaxComponent parallax;
  int vivos = 2;

  @override
  Future<void> onLoad() async {
    // Carga todas las imágenes necesarias
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
      "Owlet_Monster.png" // Asegúrate de tener esta imagen en tus assets
    ]);

    // Carga y añade el parallax (fondo)
    parallax = await ParallaxComponent.load(
      [
        ParallaxImageData('fondo.png'),
      ],
      baseVelocity: Vector2(70, 0), // Velocidad del movimiento del fondo
    );
    add(parallax);

    // Carga el mapa de Tiled
    final map = await TiledComponent.load('Mapa1.tmx', Vector2.all(32));
    map.position = Vector2.zero();
    map.priority = -1;

    // Configura la cámara
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor(0, 0);
    cameraComponent.viewfinder.zoom = 1.1;
    addAll([cameraComponent, world]);

    // Crea el jugador y añade al mundo
    player = EmberPlayer(position: Vector2(100, 100));
    player2 = Secondplayer(position: Vector2(100, 100));
    final enemy = Enemy(position: Vector2(400, 100));

    world.add(player);
    world.add(player2);
    world.add(enemy);

    // Añade los bloques del suelo al mundo
    final colisionSuelos = map.tileMap.getLayer<ObjectGroup>('suelo');
    for (final suelos in colisionSuelos!.objects) {
      world.add(GroundBlock(position: Vector2(suelos.x, suelos.y),
          size: Vector2(suelos.width, suelos.height)));
    }

    // Añade el mapa al mundo
    world.add(map);
  }

  void acabar() {
    overlays.add('gameover');
  }


}

