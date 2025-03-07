import 'dart:io';

import 'package:cli_creator/logger/logger.dart';
import 'package:cli_creator/shell_interactions/shell_interactor.dart';
import 'package:cli_creator/user_interaction/user_input.dart';
import 'package:recase/recase.dart';

class ProjectInitializer {


  Future<void> create() async {
    final name = UserInput().getInput("Your project name", "todo app");
    bool isExist = await isProjectExist(name.snakeCase);
    if (isExist) {
      ConsoleLogger().error(
          "Project with name '${name.snakeCase}' is already exist in the current directory, retry with different name or change direcotry");
    } else {
      final org =
          UserInput().getInput("Your organization domain", "com.example");

      await ShellInteractor().createProject(name: name.snakeCase, org: org);
    }
  }

  Future<bool> isProjectExist(String name) async {
    var path = Directory.current.path;
    return await Directory("$path/$name").exists();
  }
}