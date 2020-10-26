import 'package:reflectable/reflectable.dart';

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
const dependency = const Reflector();

enum DependencyScope {
  Singleton,
  Instance,
}
