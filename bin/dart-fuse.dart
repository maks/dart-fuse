import 'dart:ffi';

// FFI signature of the hello_world C function
typedef hello_world_func = Void Function();
// Dart type definition for calling the C foreign function
typedef HelloWorld = void Function();

// FFI signature of the set_callback C function
typedef NativeCbFunc = Void Function(Pointer<NativeFunction<Callback>>);
// Dart type definition for calling the C foreign function
typedef CbFunc = void Function(Pointer<NativeFunction<Callback>>);

typedef Callback = Int32 Function(Int32 a);

int callbackFromNative(int a) {
  print('Dart received: $a from native');
  return a + 1;
}

void main(List<String> arguments) {
  print('Hello from Dart!');

  final path = './fuse_library/build/libdartfuse.so';

  final dylib = DynamicLibrary.open(path);

  // ignore: omit_local_variable_types
  final CbFunc setCallback =
      dylib.lookupFunction<NativeCbFunc, CbFunc>('set_callback');

  setCallback(Pointer.fromFunction(callbackFromNative, 0));

  // Look up the C function 'hello_world'
  // ignore: omit_local_variable_types
  // final HelloWorld hello = dylib
  //     .lookup<NativeFunction<hello_world_func>>('hello_world')
  //     .asFunction();
  // // Call the function
  // hello();
}
