import 'package:reflect_example/lazy.dart';
import 'package:reflectable/reflectable.dart';

import 'dynamic_injector.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(
      invokingCapability,
      typingCapability,
      reflectedTypeCapability,
      declarationsCapability,
      delegateCapability,
      staticInvokeCapability,
      newInstanceCapability,
      typeAnnotationQuantifyCapability,
      metadataCapability,
      typeRelationsCapability,
  );
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
  final DynamicInjector innerInjector;
  ReflectedInjector(this.innerInjector) {
    innerInjector.registerSingleton<ReflectedInjector>(() => this);
    this.asSingletonSelf<LazyInject>();
  }

  void asSingleton<TInterface, TImplementation extends TInterface>() {
    innerInjector.registerSingleton<TInterface>(() => instantiate<TImplementation>(innerInjector));
  }

  void asDependency<TInterface, TImplementation extends TInterface>() {
    innerInjector.registerDependency<TInterface>(() => instantiate<TImplementation>(innerInjector));
  }

  void asSingletonSelf<T>() {
    this.asSingleton<T, T>();
  }

  void asDependencySelf<T>() {
    this.asDependency<T, T>();
  }

  T get<T>() {
    return innerInjector.get<T>();
  }
}
