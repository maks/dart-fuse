import 'dart:ffi' as ffi;

// FFI signature of the hello_world C function
typedef hello_world_func = ffi.Void Function();
// Dart type definition for calling the C foreign function
typedef HelloWorld = void Function();

void main(List<String> arguments) {
  print('Hello from Dart!');

  final path = './fuse_library/build/libfuse.so';

  final dylib = ffi.DynamicLibrary.open(path);
  // Look up the C function 'hello_world'
  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
      .asFunction();
  // Call the function
  hello();
}
