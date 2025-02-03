import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:ugh_videojuego/games/UghGame.dart';

import '../objects/ground_block.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameReference<UghGame>, KeyboardHandler, CollisionCallbacks {
  EmberPlayer({
    required super.position,
  }) : super(size: Vector2(64, 64), anchor: Anchor.center);

  late SpriteAnimation walkAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation deathAnimation;


  int horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  final double gravity = 490;
  final double jumpForce = -310;
  bool isOnGround = false;
  final double terminalVelocity = 500;
  bool isRightWall = false;
  bool isLeftWall = false;
  Vector2 previousPosition = Vector2.zero();
  bool suelocontacto = false;
  bool isDying = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RectangleHitbox(
      size: Vector2(40, 60),
      position: Vector2(12, 4),
      collisionType: CollisionType.active,
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Owlet_Monster.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2.all(32),
        stepTime: 0.12,
      ),
    );
    previousPosition = position.clone();

    walkAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Owlet_Monster_Walk_6.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2.all(32),
        stepTime: 0.12,
      ),
    );
    previousPosition = position.clone();

    jumpAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Owlet_Monster_Jump_8.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2.all(32),
        stepTime: 0.12,
      ),
    );
    previousPosition = position.clone();

    deathAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Owlet_Monster_Death_8.png'),
      // o 'Dude_Monster_Death_8.png' para Secondplayer
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(32),
        stepTime: 0.12,
        loop: false,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    previousPosition = position.clone();


      if (isDying) return;
      super.update(dt);



    if (!isRightWall && horizontalDirection > 0) {
      velocity.x = horizontalDirection * moveSpeed;
    } else if (!isLeftWall && horizontalDirection < 0) {
      velocity.x = horizontalDirection * moveSpeed;
    } else {
      velocity.x = 0;
    }

    position += velocity * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (!isOnGround) {
      velocity.y += gravity * dt;
    }

    isRightWall = false;
    isLeftWall = false;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is GroundBlock) {
      Vector2 normal;
      if (intersectionPoints.length >= 2) {
        normal = getNormal(
            intersectionPoints.elementAt(0), intersectionPoints.elementAt(1));
      } else {
        if (position.y < other.position.y) {
          normal = Vector2(0, -1);
        } else {
          normal = Vector2(0, 1);
        }
      }

      if (normal.y.abs() > normal.x.abs()) {
        if (normal.y < 0) {
          position.y = previousPosition.y;
          velocity.y = 0;
          suelocontacto = false;
        } else {
          position.y = previousPosition.y;
          velocity.y = 0;
          suelocontacto = true;
        }
      } else {
        if (normal.x < 0) {
          position.x = previousPosition.x;
          velocity.x = 0;
          isRightWall = true;
        } else {
          position.x = previousPosition.x;
          velocity.x = 0;
          isLeftWall = true;
        }
      }
    }
  }

  Vector2 getNormal(Vector2 point1, Vector2 point2) {
    final Vector2 collisionLine = point2 - point1;
    return Vector2(-collisionLine.y, collisionLine.x).normalized();
  }


  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (isDying) return true;
    horizontalDirection = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      horizontalDirection = -1;
      animation = walkAnimation;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      horizontalDirection = 1;
      animation = walkAnimation;
    }


    if (keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      jump();
    }

    return true;
  }

  void jump() {
    if (suelocontacto == true) {
      velocity.y = jumpForce;
      suelocontacto = false;
      animation = jumpAnimation;
    }
  }

  void die() {
    if (!isDying) {
      isDying = true;
      animation = deathAnimation;

      // Deshabilitar movimiento
      horizontalDirection = 0;
      velocity.x = 0;
      velocity.y = 0;

      game.vivos--;

      // Remover después de la animación
      Future.delayed(Duration(seconds: 1), () {
        removeFromParent();
      });
    }
  }
}


