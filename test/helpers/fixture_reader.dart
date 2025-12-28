import 'dart:io';

String fixture(String name) {
  final file = File('test/fixtures/$name');
  return file.readAsStringSync();
}
