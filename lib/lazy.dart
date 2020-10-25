import 'package:reflect_example/reflected_injector.dart';

@reflector
class LazyInject {
  final ReflectedInjector injector;
  LazyInject(this.injector);

  Lazy<T> as<T>() {
    return new Lazy<T>(injector);
  }
}

class Lazy<T> {
  final ReflectedInjector injector;
  Lazy(this.injector);

  T get() {
    return this.injector.get<T>();
  }
}
