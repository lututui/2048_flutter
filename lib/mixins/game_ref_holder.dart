import 'package:flame/game.dart';

abstract class IGameRefHolder<T extends Game> {
  T get gameRef;
}