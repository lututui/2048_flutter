import 'package:flame/components/component.dart';

mixin IComponentRefHolder<T extends Component> {
  T componentRef;
}