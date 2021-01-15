import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';

// FFI signature of the set_callback C function
typedef NativeCbFunc = ffi.Void Function(
    ffi.Pointer<ffi.NativeFunction<Callback>>);
// Dart type definition for the set_callback function
typedef CbFunc = void Function(ffi.Pointer<ffi.NativeFunction<Callback>>);

typedef Callback = ffi.Int32 Function(ffi.Pointer<Utf8> a);

int callbackFromNative(ffi.Pointer<Utf8> path) {
  final dartPath = Utf8.fromUtf8(path);
  print('Dart received: $dartPath from native');
  return 1;
}

// FFI signature of the fuse_init C function
typedef fuse_init_func = ffi.Void Function();
// Dart type definition for calling the C foreign function
typedef FuseInit = void Function();

void main(List<String> arguments) {
  print('dart-fuse started');

  ProcessSignal.sigint.watch().listen((signal) {
    print('dart-fuse exited');
    exit(0);
  });

  final path = './fuse_library/build/libdartfuse.so';

  final dylib = ffi.DynamicLibrary.open(path);

  // ignore: omit_local_variable_types
  final CbFunc setCallback =
      dylib.lookupFunction<NativeCbFunc, CbFunc>('set_callback');

  setCallback(ffi.Pointer.fromFunction(callbackFromNative, 0));

  // ignore: omit_local_variable_types
  final FuseInit fuseInit =
      dylib.lookupFunction<fuse_init_func, FuseInit>('fuse_init');

  fuseInit();
}
