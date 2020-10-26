import 'package:reflect_example/dynamic_injector.dart';
import 'package:reflect_example/lazy.dart';
import 'package:reflect_example/reflected_injector.dart';
import 'package:reflect_example/reflectors.dart';

import 'main.reflectable.dart';

@dependency
@DependencyScope.Singleton
class A {
  A() {
    print("A::ctor()");
  }
}

@dependency
@DependencyScope.Singleton
class B {
  final A a;
  B(this.a) {
    print("B::ctor()");
  }
  method() {
    print("B::method()");
  }
}

@dependency
@DependencyScope.Singleton
class C {
  final A a;
  final B b;
  C(this.a, this.b) {
    print("C::ctor()");
  }

  method() {
    print("C::method()");
  }
}

@dependency
@DependencyScope.Singleton
class CyclicA {
  final CyclicB cyclicB;
  CyclicA(this.cyclicB) {
    print("CyclicA::ctor()");
  }

  methodA() {
    print('calling CyclicA::methodA()');
  }
}

@dependency
@DependencyScope.Singleton
class CyclicB {
  final Lazy<CyclicA> cyclicA;
  CyclicB(LazyInject lazy):
        cyclicA = lazy.as<CyclicA>() {
    print("CyclicB::ctor()");
  }

  methodB() {
    print('calling CyclicA::methodB()');
    cyclicA.get().methodA();
  }
}

void main() {
  initializeReflectable();
  final injector = ReflectedInjector(DynamicInjector(), autoRegister: true);
  injector.get<C>().method();
  injector.get<B>().method();

  injector.get<CyclicB>().methodB();
}

// or variant with manual dependency registration
// this ignores @DependencyScope annotation
void mainManual() {
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
