import 'dart:io';
import 'package:cli_creator/file_model/file_model.dart';
import 'package:cli_creator/logger/logger.dart';
import 'package:cli_creator/shell_interactions/shell_interactor.dart';
import 'package:cli_creator/snippets/bloc_creation_snippet.dart';
import 'package:cli_creator/user_interaction/user_input.dart';
import 'package:recase/recase.dart';

class BlocInitializer {
  Future<void> createBlocInCore() async {
    final logger = ConsoleLogger();
    final name = UserInput().getInput("Enter bloc name", "ToDoBloc");
    bool isExist = await _isBlocExist("lib/core/bloc/$name".pascalCase);
    if (isExist) {
      logger.error(
          "Bloc with name '${name.pascalCase}' is already exist in the lib/core/bloc/ directory, retry with different name or change directory");
      final userResponse = UserInput().getInput("Do you want to retry?", "Y/N");
      switch (userResponse.toLowerCase()) {
        case "y":
          await createBlocInCore();
          return;
        case "n":
          return;
        default:
          logger.error("Didn't understand your response");
      }
    } else {
      logger.warning("checking for bloc...");
      final isBlocAdded =
          await ShellInteractor().addDependency(dependency: 'flutter_bloc');
      if (!isBlocAdded) {
        logger.error("Couldn't add bloc");
      }
      final path = Directory.current.path;
      final isPaginationNeeded = UserInput().getInput(
        "Is pagination required",
        "Y/N",
      );
      late final List<FileModel> files;
      switch (isPaginationNeeded.trim().toLowerCase()) {
        case "y":
          final String modelClass = UserInput().getInput(
            "Please enter the model name needed to add in the states",
            "ApiResponseModel",
          );
          files = BlocCreationSnippet().createPaginatedBloc(
            pathToCreate: "$path/lib/core/bloc/",
            name: name,
            modelClassName:
                modelClass.trim().isEmpty ? "ModelClass" : modelClass,
          );
        case "n":
          files = BlocCreationSnippet().createBloc(
            pathToCreate: "$path/lib/core/bloc/",
            name: name,
          );
        default:
          logger.error("Input not found");
          return;
      }
      
      for (final item in files) {
        final dirList = item.filePath.split('/');
        dirList.removeLast();
        await Directory(dirList.join('/')).create(recursive: true);
        final f = File(item.filePath);
        f.writeAsStringSync(item.snippet);
      }
    }
  }

  Future<void> createBlocInFeature() async {
    final logger = ConsoleLogger();
    final featureName = UserInput().getInput(
      "Enter the feature name in which bloc needed to be created if feature not found will be creating a new feature",
      "authentication",
    );
    if (featureName.trim().isEmpty) {
      logger.error("invalid input !!!");
      return;
    }
    final name = UserInput().getInput(
      "Enter bloc name",
      "ToDoBloc",
    );
    bool isExist = await _isBlocExist(
      "lib/feature/$featureName/bloc/$name".pascalCase,
    );
    if (isExist) {
      logger.error(
          "Bloc with name '${name.pascalCase}' is already exist in the lib/feature/$featureName/bloc directory, retry with different name or use different feature");
      final userResponse = UserInput().getInput(
        "Do you want to retry?",
        "Y/N",
      );
      switch (userResponse.toLowerCase()) {
        case "y":
          await createBlocInFeature();
          return;
        case "n":
          return;
        default:
          logger.error("Didn't understand your response");
          return;
      }
    } else {
      logger.warning("checking for bloc...");
      final isBlocAdded = await ShellInteractor().addDependency(
        dependency: 'flutter_bloc',
      );
      if (!isBlocAdded) {
        logger.error("Couldn't add bloc");
        return;
      }
      final path = Directory.current.path;
      final isPaginationNeeded = UserInput().getInput(
        "Is pagination required",
        "Y/N",
      );
      late final List<FileModel> files;
      switch (isPaginationNeeded.trim().toLowerCase()) {
        case "y":
          final String modelClass = UserInput().getInput(
            "Please enter the model name needed to add in the states",
            "ApiResponseModel",
          );
          files = BlocCreationSnippet().createPaginatedBloc(
            pathToCreate: "$path/lib/feature/$featureName/bloc/",
            name: name,
            modelClassName:
                modelClass.trim().isEmpty ? "ModelClass" : modelClass,
          );
        case "n":
          files = BlocCreationSnippet().createBloc(
            pathToCreate: "$path/lib/feature/$featureName/bloc/",
            name: name,
          );
        default:
          logger.error("Input not found");
          return;
      }
      for (final item in files) {
        final dirList = item.filePath.split('/');
        dirList.removeLast();
        await Directory(dirList.join('/')).create(recursive: true);
        final f = File(item.filePath);
        f.writeAsStringSync(item.snippet);
      }
    }
  }

  Future<bool> _isBlocExist(String relativePath) async {
    final path = Directory.current.path;
    return await Directory("$path/$relativePath").exists();
  }
}
