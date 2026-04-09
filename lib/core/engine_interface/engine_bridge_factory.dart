// engine_bridge_factory.dart
import 'engine_bridge_interface.dart';
import 'engine_bridge_stub.dart'
    if (dart.library.ffi) 'engine_bridge.dart'
    if (dart.library.js_interop) 'engine_bridge_web.dart';

EngineBridgeInterface getEngineBridge() => createEngineBridge();