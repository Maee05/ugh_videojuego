import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class GroundBlock extends PositionComponent with CollisionCallbacks {
  GroundBlock({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topLeft) {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}