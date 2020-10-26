import 'package:reflect_example/lazy.dart';
import 'package:reflect_example/reflectors.dart';
import 'package:reflectable/reflectable.dart';

import 'dynamic_injector.dart';

MethodMirror getCtor(ClassMirror mirror) {
  return mirror.declarations.values.where((declare) {
    return declare is MethodMirror && declare.isConstructor;
  }).first;
}

T instantiate<T>(DynamicInjector injector) {
  ClassMirror mirror = dependency.reflectType(T);

  final ctor = getCtor(mirror);
  final ctorArgsTypes = ctor.parameters.map((p) => p.type);
  final args = ctorArgsTypes.map((t) => injector.getDynamic(t.reflectedType));
  return mirror.newInstance('', args.toList());
}

dynamic instantiateWithAutoRegister(DynamicInjector injector, Type t) {
  if (injector.existsDynamic(t)) {
    return injector.getDynamic(t);
  }

  ClassMirror mirror = dependency.reflectType(t);
  final ctor = getCtor(mirror);
  final ctorArgsTypes = ctor.parameters.map((p) => p.type);
  final provider = () {
    final args = ctorArgsTypes.map((t) {
      return instantiateWithAutoRegister(injector, t.reflectedType);
    });
    return mirror.newInstance('', args.toList());
  };

  final isSingleton = mirror.metadata.contains(DependencyScope.Singleton);
  final isInstance = mirror.metadata.contains(DependencyScope.Instance);

  if (isSingleton) {
    injector.registerSingletonDynamic(t, provider);
  } else if (isInstance) {
    injector.registerDependencyDynamic(t, provider);
  } else {
    throw new Exception('Could not determine dependency scope');
  }

  return injector.getDynamic(t);
}

class ReflectedInjector {
  final DynamicInjector innerInjector;
  final bool autoRegister;
  ReflectedInjector(this.innerInjector, { this.autoRegister = false }) {
    this.asExistingInstanceSelf(this);
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

  void asExistingInstanceSelf<T>(T instance) {
    innerInjector.registerSingleton<T>(() => instance);
  }

  T get<T>() {
    return autoRegister ? instantiateWithAutoRegister(innerInjector, T) : innerInjector.get<T>();
  }
}
