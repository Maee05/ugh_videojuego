import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:ugh_videojuego/players/EmberPlayer.dart';
import 'package:ugh_videojuego/players/Secondplayer.dart';
import 'package:ugh_videojuego/games/UghGame.dart';

class Enemy extends SpriteAnimationComponent with HasGameReference<UghGame>, CollisionCallbacks {
  Enemy({required super.position}) : super(size: Vector2(64, 64), anchor: Anchor.center);

  // Velocidad de movimiento del enemigo
  final double moveSpeed = 80;
  Vector2 velocity = Vector2.zero();
  bool isMovingLeft = false;

  @override
  Future<void> onLoad() async {
    // Añadir hitbox para colisiones
    add(RectangleHitbox(
      size: Vector2(40, 60),
      position: Vector2(12, 4),
      collisionType: CollisionType.active,
    ));

    // Cargar animación de caminar
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Pink_Monster_Jump_8.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(32),
        stepTime: 0.12,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Obtener las posiciones de ambos jugadores
    var player1 = game.player;
    var player2 = game.player2;

    // Si algún jugador ha sido removido, no lo consideramos
    if (player1.isRemoved && player2.isRemoved) return;

    var target = _getClosestPlayer(player1, player2);
    if (target != null) {
      _moveTowardsTarget(target, dt);
    }
  }

  // Encuentra el jugador más cercano
  PositionComponent? _getClosestPlayer(EmberPlayer player1, Secondplayer player2) {
    if (player1.isRemoved) return player2;
    if (player2.isRemoved) return player1;

    var dist1 = (player1.position - position).length;
    var dist2 = (player2.position - position).length;

    return dist1 < dist2 ? player1 : player2;
  }

  // Mueve el enemigo hacia el objetivo
  void _moveTowardsTarget(PositionComponent target, double dt) {
    var direction = (target.position - position).normalized();
    velocity = direction * moveSpeed;
    position += velocity * dt;

    // Voltear el sprite según la dirección
    if (velocity.x < 0 && !isMovingLeft) {
      flipHorizontally();
      isMovingLeft = true;
    } else if (velocity.x > 0 && isMovingLeft) {
      flipHorizontally();
      isMovingLeft = false;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is EmberPlayer || other is Secondplayer) {
      // Asegurarse de que el jugador no esté ya muriendo
      if (other is EmberPlayer) {
        if (!other.isDying) other.die();
      } else if (other is Secondplayer) {
        if (!other.isDying) other.die();
      }
    }
  }
}