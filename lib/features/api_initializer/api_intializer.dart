import 'dart:io';

import 'package:cli_creator/constants/constants_string.dart';
import 'package:cli_creator/file_model/file_model.dart';
import 'package:cli_creator/logger/logger.dart';
import 'package:cli_creator/shell_interactions/shell_interactor.dart';
import 'package:cli_creator/snippets/api_creation_snippet.dart';
import 'package:cli_creator/user_interaction/user_input.dart';
import 'package:recase/recase.dart';

class ApiIntializer {
  Future<void> createApiInCore() async {
    final logger = ConsoleLogger();
    final endPoint =
        UserInput().getInput("Enter api end point", "/api/v1/api_name");
    final apiName = "${endPoint.split('/').last.snakeCase}_api.dart";
    bool isExist = await _isApiExist("core/services/$apiName");
    logger.warning("For now only GET and POST are allowed");
    final method = UserInput().getInput(
      "enter the api method",
      "POST/GET",
    );
    if (!ConstantsString.dioMethods.contains(method.trim().toLowerCase())) {
      logger.error("SORRY!!, GET and POST are allowed");
      return;
    }
    if (isExist) {
      logger.error(
        "API with name '$apiName' is already exist in the core/services/ directory, retry with different name or change directory",
      );
      final userResponse = UserInput().getInput("Do you want to retry?", "Y/N");
      switch (userResponse.trim().toLowerCase()) {
        case "y":
          await createApiInCore();
          return;
        case "n":
          return;
        default:
          logger.error("Didn't understand your response");
          return;
      }
    } else {
      logger.warning("checking for dio...");
      final isDioAdded =
          await ShellInteractor().addDependency(dependency: 'dio');
      if (!isDioAdded) {
        logger.error("Couldn't add dio");
      }
      final String modelClass = UserInput().getInput(
        "Please enter the model name needed to add in the states",
        "ApiResponseModel",
      );
      final path = Directory.current.path;
      final isPaginationNeeded = UserInput().getInput(
        "Is pagination required",
        "Y/N",
      );
      late final List<FileModel> files;
      switch (isPaginationNeeded.trim().toLowerCase()) {
        case "y":
          files = ApiCreationSnippet().createApi(
            pathToCreate: "$path/core/services/",
            apiEndPoint: endPoint,
            modelName: modelClass.trim().isEmpty ? "ModelClass" : modelClass,
            isPaginated: true,
            method: method.trim().toLowerCase(),
          );
        case "n":
          files = ApiCreationSnippet().createApi(
            pathToCreate: "$path/core/services/",
            apiEndPoint: endPoint,
            modelName: modelClass.trim().isEmpty ? "ModelClass" : modelClass,
            isPaginated: true,
            method: method.trim().toLowerCase(),
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

  Future<void> createApiInFeature() async {
    final logger = ConsoleLogger();
    final featureName =
        UserInput().getInput("Enter the feature name", 'authentication');
    final endPoint =
        UserInput().getInput("Enter api end point", "/api/v1/api_name");
    final apiName = "${endPoint.split('/').last.snakeCase}_api.dart";
    bool isExist = await _isApiExist("lib/feature/$featureName/services/$apiName");
    logger.warning("For now only GET and POST are allowed");
    final method = UserInput().getInput(
      "enter the api method",
      "POST/GET",
    );
    if (!ConstantsString.dioMethods.contains(method.trim().toLowerCase())) {
      logger.error("SORRY!!, GET and POST are allowed");
      return;
    }
    if (isExist) {
      logger.error(
        "API with name '$apiName' is already exist in the lib/feature/$featureName/services/ directory, retry with different name or change directory",
      );
      final userResponse = UserInput().getInput("Do you want to retry?", "Y/N");
      switch (userResponse.trim().toLowerCase()) {
        case "y":
          await createApiInCore();
          return;
        case "n":
          return;
        default:
          logger.error("Didn't understand your response");
          return;
      }
    } else {
      logger.warning("checking for dio...");
      final isDioAdded =
          await ShellInteractor().addDependency(dependency: 'dio');
      if (!isDioAdded) {
        logger.error("Couldn't add dio");
      }
      final String modelClass = UserInput().getInput(
        "Please enter the model name needed to add in the states",
        "ApiResponseModel",
      );
      final path = Directory.current.path;
      final isPaginationNeeded = UserInput().getInput(
        "Is pagination required",
        "Y/N",
      );
      late final List<FileModel> files;
      switch (isPaginationNeeded.trim().toLowerCase()) {
        case "y":
          files = ApiCreationSnippet().createApi(
            pathToCreate: "$path/lib/feature/$featureName/services/",
            apiEndPoint: endPoint,
            modelName: modelClass.trim().isEmpty ? "ModelClass" : modelClass,
            isPaginated: true,
            method: method.trim().toLowerCase(),
          );
        case "n":
          files = ApiCreationSnippet().createApi(
            pathToCreate: "$path/lib/feature/$featureName/services/",
            apiEndPoint: endPoint,
            modelName: modelClass.trim().isEmpty ? "ModelClass" : modelClass,
            isPaginated: true,
            method: method.trim().toLowerCase(),
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

  Future<bool> _isApiExist(String relativePath) async {
    final path = Directory.current.path;
    return await File("$path/$relativePath").exists();
  }
}
