import 'dart:io';
import 'package:cli_creator/logger/logger.dart';

class UserInput {
  String getInput(String question, String example) {
    ConsoleLogger().question(question);
    ConsoleLogger().example("Eg: $example");
    final input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input;
    } else {
      ConsoleLogger().error("Sorry value not acceptable!!");
      return getInput(question, example);
    }
  }
}
