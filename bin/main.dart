import 'package:reflect_example/dynamic_injector.dart';
import 'package:reflect_example/reflected_injector.dart';

import 'main.reflectable.dart';

@reflector
class A {
}

@reflector
class B {
  final A a;
  B(this.a);
}

@reflector
class C {
  final A a;
  final B b;
  C(this.a, this.b);

  method() {
    return "I'm C's method";
  }
}


void main() {
  initializeReflectable();
  final injector = ReflectedInjector(new DynamicInjector());

  injector.asSingletonSelf<A>();
  injector.asSingletonSelf<B>();
  injector.asSingletonSelf<C>();

  print(injector.get<C>().method());
}
