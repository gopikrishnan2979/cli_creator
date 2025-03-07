import 'dart:io' as io;
import 'package:dcli/dcli.dart';

class ConsoleLogger {
  void error(String error) => io.stdout.write(red(error));

  void message(String message) => io.stdout.write(white(message));

  void warning(String message) => io.stdout.write(yellow(message));

  void question(String question) => io.stdout.write(orange(question));

  void example(String example) => io.stdout.write(grey(example));

  void successMessage(String message) => io.stdout.write(green(message));
}
