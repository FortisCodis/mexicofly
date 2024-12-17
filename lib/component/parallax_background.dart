import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mexicofly/bloc/game/game_cubit.dart';
import 'package:mexicofly/flappy_game.dart';

class ParallaxBackground extends ParallaxComponent<FlappyGame> with FlameBlocReader<GameCubit, GameState> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    parallax = await game.loadParallax([
      ParallaxImageData('bg_sky.png'),
      ParallaxImageData('bg_back.png'),
      ParallaxImageData('bg_desert.png'),
      ParallaxImageData('bg_fore.png'),
    ], baseVelocity: Vector2(8, 0), velocityMultiplierDelta: Vector2(2, 0));
  }

  @override
  void update(double dt) {

    switch(bloc.state.currentPlayingState){
      case PlayingState.paused:
      case PlayingState.gameOver:
        return;
      case PlayingState.none:
      case PlayingState.playing:
        break;
    }
    super.update(dt);
  }
}