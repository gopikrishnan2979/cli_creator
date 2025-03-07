import 'package:cli_creator/file_model/file_model.dart';
import 'package:cli_creator/snippets/snippets.dart';
import 'package:recase/recase.dart';

class BlocCreationSnippet {
  List<FileModel> createBloc(
      {required String pathToCreate, required String name}) {
    final fileName = name.paramCase.toLowerCase().replaceAll('-', '_');
    return [
      FileModel(
        pathToCreate,
        "${fileName}_bloc.dart",
        Snippets().getCreateBloc(
          blocName: name,
          fileName: fileName,
        ),
      ),
      FileModel(
        pathToCreate,
        "${fileName}_state.dart",
        Snippets().getCreateBlocState(
          blocName: name,
          fileName: fileName,
        ),
      ),
      FileModel(
        pathToCreate,
        "${fileName}_event.dart",
        Snippets().getCreateBlocEvent(
          blocName: name,
          fileName: fileName,
        ),
      ),
    ];
  }

  List<FileModel> createCubit(
      {required String pathToCreate, required String name}) {
    final fileName = name.paramCase.toLowerCase().replaceAll('-', '_');
    return [
      FileModel(
        pathToCreate,
        "${fileName}_cubit.dart",
        Snippets().getCreateCubit(
          cubitName: name,
          fileName: fileName,
        ),
      ),
      FileModel(
        pathToCreate,
        "${fileName}_state.dart",
        Snippets().getCreateCubitState(
          cubitName: name,
          fileName: fileName,
        ),
      ),
    ];
  }

  List<FileModel> createPaginatedBloc({
    required String pathToCreate,
    required String name,
    required String modelClassName,
  }) {
    final fileName = name.paramCase.toLowerCase().replaceAll('-', '_');
    return [
      FileModel(
        pathToCreate,
        "${fileName}_bloc.dart",
        Snippets().getCreatePaginatedBloc(
          blocName: name,
          fileName: fileName,
        ),
      ),
      FileModel(
        pathToCreate,
        "${fileName}_state.dart",
        Snippets().getCreatePaginatedState(
          blocName: name,
          fileName: fileName,
          modelClassName: modelClassName,
        ),
      ),
      FileModel(
        pathToCreate,
        "${fileName}_event.dart",
        Snippets().getCreatePaginatedEvent(
          blocName: name,
          fileName: fileName,
        ),
      ),
    ];
  }
}
