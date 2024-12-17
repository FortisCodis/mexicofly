import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mexicofly/bloc/game/game_cubit.dart';
import 'package:mexicofly/component/coin.dart';
import 'package:mexicofly/component/pipe.dart';
import 'package:mexicofly/flappy_game.dart';

class Player extends PositionComponent
    with CollisionCallbacks, HasGameRef<FlappyGame>, FlameBlocReader<GameCubit, GameState> {
  Player()
      : super(
          position: Vector2(0, 0),
          size: Vector2(120, 120),
          anchor: Anchor.center,
        );

  late Sprite _playerSprite;

  final Vector2 _gravity = Vector2(0, 1400);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 jumpForce = Vector2(0, -600);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final radius = size.x / 2;
    final center = size / 2;
    _playerSprite = await Sprite.load('player.png');
    add(CircleHitbox(
        radius: radius * 0.8, position: center * 1.1, anchor: Anchor.center));
  }

  @override
  void update(dt) {
    super.update(dt);
    switch(bloc.state.currentPlayingState){
      case PlayingState.none:
      case PlayingState.paused:
      case PlayingState.gameOver:
        _velocity = Vector2.zero();
        break;
      case PlayingState.playing:
        _velocity += _gravity * dt;
        break;
    }

    position += _velocity * dt;
  }

  void jump() {
    _velocity = jumpForce;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    debugMode = true;
    _playerSprite.render(canvas, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Coin) {
      bloc.increaseScore();
      other.removeFromParent();
    } else if (other is Pipe) {
      bloc.gameOver();
    }
  }
}
