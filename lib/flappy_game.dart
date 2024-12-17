import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mexicofly/bloc/game/game_cubit.dart';

import 'package:mexicofly/component/parallax_background.dart';
import 'package:mexicofly/component/pipe_pair.dart';
import 'package:mexicofly/component/player.dart';

class FlappyGame extends FlameGame<FlappyWorld>
    with KeyboardEvents, HasCollisionDetection {
  FlappyGame(this.gameCubit)
      : super(
          world: FlappyWorld(),
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1200,
          ),
        );

  final GameCubit gameCubit;

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      world.onSpaceDown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class FlappyWorld extends World with HasGameRef<FlappyGame>, TapCallbacks {
  late FlappyRootComponent _rootComponent;

  @override
  void onLoad() {
    super.onLoad();
    add(FlameBlocProvider<GameCubit, GameState>(create: () => game.gameCubit, children: [
      _rootComponent = FlappyRootComponent(),
    ]));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _rootComponent.onTapDown(event);
  }

  void onSpaceDown() => _rootComponent.onSpaceDown();
}

class FlappyRootComponent extends Component
    with HasGameRef<FlappyGame>, FlameBlocReader<GameCubit, GameState> {
  late Player _player;
  late PipePair _lastPipe;

  static const double _pipeDistance = 400.0;
  static const int _nbPipesGenerated = 1;

  late TextComponent _scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(ParallaxBackground());
    add(_player = Player());
    _generatePipes(count: _nbPipesGenerated, fromX: 350);
    game.camera.viewfinder.add(_scoreText = TextComponent(
      position: Vector2(0, -game.size.y / 2),
    ));

    game.camera.viewfinder.add(FpsTextComponent(
        position: Vector2(-game.size.x / 2, -game.size.y / 2)
    ));
  }

  void _generatePipes(
      {required int count, double fromX = 0.0, double distance = 400.0}) {
    print("Pipe Generated.");
    for (int i = 0; i <= count; i++) {
      const area = 600;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe = PipePair(position: Vector2(fromX + (distance * i), y)));
    }
  }

  void _removePipes({required int count}) {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - count, 0);

    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
    print("Pipe Removed.");
  }

  void _checkToStart() {
    if (bloc.state.currentPlayingState == PlayingState.none) {
      bloc.startPlaying();
    }
  }

  void onTapDown(TapDownEvent event) {
    _checkToStart();
    _player.jump();
  }

  void onSpaceDown() {
    _checkToStart();
    _player.jump();
  }

  @override
  void update(dt) {
    super.update(dt);
    _scoreText.text = bloc.state.currentScore.toString();
    if (_player.x >= _lastPipe.x) {
      _generatePipes(count: _nbPipesGenerated, fromX: _pipeDistance);

      _removePipes(count: _nbPipesGenerated);
    }
  }


}
