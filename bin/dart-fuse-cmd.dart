import 'dart:io';

import 'package:dart_fuse/dart-fuse.dart';

void main(List<String> arguments) {
  ProcessSignal.sigint.watch().listen((signal) {
    print('dart-fuse exited');
    exit(0);
  });

  final fuse = DartFuse(getAttributes: (path) {
    print('get attr requested');
  });
  fuse.init(arguments);
}
