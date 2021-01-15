import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

// FFI signature of the set_callback C function
typedef NativeCbFunc = ffi.Void Function(
    ffi.Pointer<ffi.NativeFunction<Callback>>);
// Dart type definition for the set_callback function
typedef CbFunc = void Function(ffi.Pointer<ffi.NativeFunction<Callback>>);

typedef Callback = ffi.Int32 Function(ffi.Int32 op, ffi.Pointer<Utf8> path);

int callbackFromNative(int op, ffi.Pointer<Utf8> path) {
  final dartPath = Utf8.fromUtf8(path);
  print('Dart received: [$op] $dartPath from native');
  final operation = FuseOp.values[op];
  switch (operation) {
    case FuseOp.GetAttr:
      DartFuse._singleton.getAttributes?.call(dartPath);
      break;
    case FuseOp.Open:
      // TODO: Handle this case.
      break;
    case FuseOp.Read:
      // TODO: Handle this case.
      break;
    case FuseOp.ReadDir:
      // TODO: Handle this case.
      break;
  }
  return 1;
}

// FFI signature of the fuse_init C function
typedef fuse_init_func = ffi.Void Function(
    ffi.Int32 argc, ffi.Pointer<ffi.Pointer<Utf8>> argv);
// Dart type definition for calling the C foreign function
typedef FuseInit = void Function(int argc, ffi.Pointer<ffi.Pointer<Utf8>> argv);

class DartFuse {
  final Function(String path) getAttributes;

  static DartFuse _singleton;

  DartFuse._({this.getAttributes});

  factory DartFuse({getAttributes}) {
    _singleton ??= DartFuse._(getAttributes: getAttributes);
    return _singleton;
  }

  void init(List<String> arguments) {
    print('dart-fuse started');
    final path = './fuse_library/build/libdartfuse.so';
    final dylib = ffi.DynamicLibrary.open(path);

    // ignore: omit_local_variable_types
    final CbFunc setCallback =
        dylib.lookupFunction<NativeCbFunc, CbFunc>('set_callback');
    setCallback(ffi.Pointer.fromFunction(callbackFromNative, 0));

    // ignore: omit_local_variable_types
    final FuseInit fuseInit =
        dylib.lookupFunction<fuse_init_func, FuseInit>('fuse_init');
    fuseInit(arguments.length, _convertForFFI(arguments));
  }

  ffi.Pointer<ffi.Pointer<Utf8>> _convertForFFI(List<String> strings) {
    // ignore: omit_local_variable_types
    final List<ffi.Pointer<Utf8>> stringPointers =
        strings.map(Utf8.toUtf8).toList();
    // ignore: omit_local_variable_types
    final ffi.Pointer<ffi.Pointer<Utf8>> pointerToStringPointers =
        allocate(count: stringPointers.length);
    for (var i = 0; i < strings.length; i++) {
      pointerToStringPointers[i] = stringPointers[i];
    }
    return pointerToStringPointers;
  }
}

class FileAttributes {
  final int mode;
  final int linkCount;
  final int size;

  FileAttributes(this.mode, this.linkCount, this.size);
}

// from: linux kernels errno.h
class FileErrors {
  static const ENOENT = 2;
}

enum FuseOp {
  GetAttr,
  Open,
  Read,
  ReadDir,
}
