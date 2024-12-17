import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mexicofly/bloc/game/game_cubit.dart';
import 'package:mexicofly/component/coin.dart';
import 'package:mexicofly/component/pipe.dart';

class PipePair extends PositionComponent
    with FlameBlocReader<GameCubit, GameState> {
  PipePair({
    required super.position,
    this.gap = 150.0,
    this.speed = 100.0,
  }) : super();

  final double gap;
  final double speed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      Pipe(
        isFlipped: false,
        position: Vector2(0, gap),
      ),
      Pipe(
        isFlipped: true,
        position: Vector2(0, -gap),
      ),
      Coin(
        position: Vector2(0, 0),
      ),
    ]);
  }

  @override
  void update(dt) {
    switch(bloc.state.currentPlayingState){
      case PlayingState.none:
      case PlayingState.paused:
      case PlayingState.gameOver:
        // No move.
        break;
      case PlayingState.playing:
        position.x -= speed * dt;
        break;
    }
    super.update(dt);

  }
}
