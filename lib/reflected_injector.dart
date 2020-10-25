import 'package:reflectable/reflectable.dart';

import 'dynamic_injector.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, typingCapability, reflectedTypeCapability, declarationsCapability, delegateCapability, staticInvokeCapability, newInstanceCapability);
}

const reflector = const Reflector();

MethodMirror getCtor(ClassMirror mirror) {
  return mirror.declarations.values.where((declare) {
    return declare is MethodMirror && declare.isConstructor;
  }).first;
}

T instantiate<T>(DynamicInjector injector) {
  ClassMirror mirror = reflector.reflectType(T);
  final ctor = getCtor(mirror);
  final ctorArgsTypes = ctor.parameters.map((p) => p.type);
  final args = ctorArgsTypes.map((t) => injector.getDynamic(t.reflectedType));
  return mirror.newInstance('', args.toList());
}

class ReflectedInjector {
  final DynamicInjector injector;
  ReflectedInjector(this.injector);

  asSingleton<TInterface, TImplementation extends TInterface>() {
    injector.registerSingleton<TInterface>(() => instantiate<TImplementation>(injector));
  }

  asDependency<TInterface, TImplementation extends TInterface>() {
    injector.registerDependency<TInterface>(() => instantiate<TImplementation>(injector));
  }

  asSingletonSelf<T>() {
    this.asSingleton<T, T>();
  }

  asDependencySelf<T>() {
    this.asDependency<T, T>();
  }

  T get<T>() {
    return injector.get<T>();
  }
}
