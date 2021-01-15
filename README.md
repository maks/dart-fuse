# Dart FFI bindings for FUSE

## How to use

## Status

- [x] Pass in command line args to Fuse main()
- [x] Library structure and example working for: getattr
- [ ] Minimal implementation: open, read, readdir
- [ ] Implement more common operations: create, write, unlink, mkdir, rmdir, release, rename, truncate, destroy 
- [ ] Full API from [fuse.h](http://libfuse.github.io/doxygen/structfuse__operations.html)


# References

## Dart FFI

[The main docs for FFI](https://dart.dev/guides/libraries/c-interop)

[Tutorial for basics of using Dart FFI](https://github.com/dart-lang/sdk/blob/master/samples/ffi/sqlite/docs/sqlite-tutorial.md)

[Example code of how to pass in String (using `Pointer<Utf8>`)](https://github.com/dart-lang/sdk/blob/master/samples/ffi/sqlite/lib/src/bindings/signatures.dart#L11)


[This issue comment actually had one of the best, clearest examples of code to do callback into Dart from C](https://github.com/dart-lang/sdk/issues/37301#issuecomment-602197373), more so than the [example code in the issue that tracked callback implementation.](https://github.com/dart-lang/sdk/issues/35761#issue-403159732)

[Practical example of using existing C library including setup for mobile](https://medium.com/flutter-community/integrating-c-library-in-a-flutter-app-using-dart-ffi-38a15e16bc14)

[How to pass String arrays from Dart to C](https://github.com/dart-lang/sdk/issues/43403)

## CMake

[Good explanation of basics of CMake file](https://stackoverflow.com/a/45843676/85472)

## FUSE

[Excellent tutorial with example code on basic use of FUSE in C including how to configure with CMake](https://engineering.facile.it/blog/eng/write-filesystem-fuse/)

[The use in TabFS which inspired this package in first place](https://github.com/osnr/TabFS/blob/master/fs/tabfs.c)

