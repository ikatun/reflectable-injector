import 'package:reflect_example/dynamic_injector.dart';
import 'package:reflect_example/lazy.dart';
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
    print("I'm C's method");
  }
}

@reflector
class CyclicA {
  final CyclicB cyclicB;
  CyclicA(this.cyclicB);

  methodA() {
    print('calling CyclicA::methodA()');
  }
}

@reflector
class CyclicB {
  final Lazy<CyclicA> cyclicA;
  CyclicB(LazyInject lazy):
        cyclicA = lazy.as<CyclicA>();

  methodB() {
    print('calling CyclicA::methodB()');
    cyclicA.get().methodA();
  }
}


void main() {
  initializeReflectable();
  final injector = ReflectedInjector(DynamicInjector());

  injector.asSingletonSelf<A>();
  injector.asSingletonSelf<B>();
  injector.asSingletonSelf<C>();
  injector.get<C>().method();

  injector.asSingletonSelf<CyclicA>();
  injector.asSingletonSelf<CyclicB>();

  injector.get<CyclicB>().methodB();
}
