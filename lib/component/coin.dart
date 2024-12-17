import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Coin extends PositionComponent {
  Coin({
    required super.position,
}) : super(
    size: Vector2(24, 24),
    anchor: Anchor.center,
  );

  @override
  void onLoad() {
    super.onLoad();

    add(CircleHitbox(
      collisionType: CollisionType.passive
    ));
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle((size / 2).toOffset(), size.x / 2, BasicPalette.yellow.paint());
  }
}