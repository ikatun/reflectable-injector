import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(
    invokingCapability,
    reflectedTypeCapability,
    metadataCapability,
  );
}
const dependency = const Reflector();

enum DependencyScope {
  Singleton,
  Instance,
}
