import 'package:cli_creator/file_model/file_model.dart';
import 'package:cli_creator/snippets/snippets.dart';
import 'package:recase/recase.dart';

class ApiCreationSnippet {
   List<FileModel> createApi({
    required String method,
    required String pathToCreate,
    required String apiEndPoint,
    required String modelName,
    required bool isPaginated,
  }) {
    final fileName = apiEndPoint.split('/').last.snakeCase;
    return [
      FileModel(
        pathToCreate,
        "${fileName}_api.dart",
        Snippets().createApi(
          apiEndPoint: apiEndPoint,
          fileCreationPath: pathToCreate,
          method: method,
          modelName: modelName,
          isPaginated: isPaginated,
        ),
      )
    ];
  }
}