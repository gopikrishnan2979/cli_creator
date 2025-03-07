import 'dart:io';

import 'package:recase/recase.dart';

class Snippets {
  String _findPackageName() {
    final path = Directory.current.path;
    return path.split('/').last;
  }

  /// content for normal bloc
  String getCreateBloc({required String blocName, required String fileName}) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';

part '${fileName}_bloc.dart';

part '${fileName}_state.dart';

class ${blocName}Bloc extends Bloc<${blocName}Event, ${blocName}State> {
  ${blocName}Bloc() : super(${blocName}Initial()) {

    on<Get$blocName>((event, emit) async {
      
    });
  }
}
''';
  }

  /// content for normal event
  String getCreateBlocEvent(
      {required String blocName, required String fileName}) {
    return '''
part of '${fileName}_bloc.dart';

abstract class ${blocName}Event {}

final class Get$blocName extends ${blocName}Event {

}
''';
  }

  ///content for normal state
  String getCreateBlocState(
      {required String blocName, required String fileName}) {
    return '''
part of '${fileName}_bloc.dart';

abstract class ${blocName}State {}

final class ${blocName}Initial extends ${blocName}State {}
''';
  }

  /// content for normal cubit
  String getCreateCubit({required String cubitName, required String fileName}) {
    return """
import 'package:flutter_bloc/flutter_bloc.dart';

part '${fileName}_state.dart';

class ${cubitName}Cubit extends Cubit<${cubitName}State> {
  ${cubitName}Cubit(): super(${cubitName}State());
}
""";
  }

  /// content for normal cubit state
  String getCreateCubitState(
      {required String cubitName, required String fileName}) {
    return """
part of '${fileName}_cubit.dart';

abstract class ${cubitName}State {}
""";
  }

  /// content for paginated bloc
  String getCreatePaginatedBloc(
      {required String blocName, required String fileName}) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';

part '${fileName}_bloc.dart';

part '${fileName}_state.dart';

//TODO: import necessary file for [modelData] and api
class ${blocName}Bloc extends Bloc<${blocName}Event, ${blocName}State> {
  SubBusinessCategoryApiBloc() : super(SubCategoryInitial()) {
    on<Get$blocName>((event, emit) async {
      emit(${blocName}Loading());
      //TODO: add your api here along 
      final response = await ApiName(
        token: event.token,
        limit: 16,
        offset: 0,
      );
      if (response.status) {
        emit(${blocName}Loaded(
          modelData: response,
        ));
        return;
      }
      emit(${blocName}Failed(error: response.message));
    });

    on<Paginate$blocName>((event, emit) async {
      if (state is ${blocName}Loaded && state is! ${blocName}PLoading && state is! ${blocName}PFinished) {
        final currentState = state as ${blocName}Loaded;
        // TODO add your pagination Finishing condition here [currentState.modelData.data] replace with paginating list data
        if (currentState.modelData.totalResults <=
            currentState.modelData.data.length) {
          emit(SubCategoryPFinished(
            mainCategoryId: currentState.mainCategoryId,
            modelData: currentState.modelData,
          ));
          return;
        }
        emit(${blocName}PLoading(
          modelData: currentState.modelData,
        ));
        // add api name here
        final response = await ApiName(
          token: event.token,
          limit: 16,
          offset:currentState.modelData.data.length ,
        );
        if (response.status) {
          emit(${blocName}Loaded(
            modelData: response.copyWith(
              data: [
                ...currentState.modelData.data,
                ...response.data
              ],
            ),
          ));
          return;
        }
        emit(${blocName}PFailed(
          error: response.message,
          modelData: currentState.modelData,
        ));
      }

    });
  }
}

''';
  }

  /// content for paginated event
  String getCreatePaginatedEvent(
      {required String blocName, required String fileName}) {
    return '''
part of '${fileName}_bloc.dart';

abstract class ${blocName}Event {
final String token;
  ${blocName}Event({required this.token});
}

final class Get$blocName extends ${blocName}Event {
  Get$blocName({required super.token})
}

final class Paginate$blocName extends ${blocName}Event {
  Paginate$blocName({required super.token})
}

''';
  }

  ///content for normal state
  String getCreatePaginatedState(
      {required String blocName,
      required String fileName,
      required String modelClassName}) {
    return '''
part of '${fileName}_bloc.dart';

abstract class ${blocName}State {}

final class ${blocName}Initial extends ${blocName}State {}

final class ${blocName}Loading extends ${blocName}State {}

final class ${blocName}Failed extends ${blocName}State {
  final String error;
  ${blocName}Failed({required this.error});
}

final class ${blocName}Loaded extends ${blocName}State {
  final $modelClassName modelData;
  ${blocName}Loaded({required this.modelData});
}

final class ${blocName}PLoading extends ${blocName}Loaded {
  ${blocName}PLoading({required super.modelData});
}

final class ${blocName}PFailed extends ${blocName}Loaded {
  final String error;
  ${blocName}PFailed({required super.modelData,required this.error});
}

final class ${blocName}PFinished extends ${blocName}Loaded {
  ${blocName}PFinished({required super.modelData});
}

''';
  }

  String addApiUrl({required String apiEndPoint, required String method}) {
    final apiName = apiEndPoint.split('/').last.pascalCase;
    return '''
const $method${apiName}Url = "$apiEndPoint";
''';
  }

  String createApi({
    required String apiEndPoint,
    required String method,
    required String modelName,
    required String fileCreationPath,
    required bool isPaginated,
  }) {
    final apiName = apiEndPoint.split('/').last.pascalCase;
    var pathSpliter = fileCreationPath.split('/');
    pathSpliter.removeLast();
    final modelPath = "${pathSpliter.join('/')}/model";
    return '''
import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:/core/constants/url_constants.dart';
import 'package:${_findPackageName()}/$modelPath/${modelName.snakeCase}.dart';

class ${apiName}Api {
  final _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<> getFlick({required String token,${isPaginated ? "required int offset,required int limit," : ""}}) async {
    // TODO: add your data params here
    Map<String, dynamic> data = {
      ${isPaginated ? '''
        "offset":offset,
        "limit":limit,''' : ""}
    };
    final url = $method${apiName}Url;
    try {
      final response = await _dio.$method(
        url,
        options: Options(
        headers: {
          "Authorization": ${"Bearer \$token"},
          },
        ),
        data: data,
      );
      if (response.statusCode == HttpStatus.ok) {
        final model = $modelName.fromJson(response.data);
        return model;
      }
      //TODO: add the appropriate [data] here
      return $modelName(status: false,message: kUnexpectedError,data:null);
    } on DioException catch (e, s) {
      AppLogger.printExceptionLog(name: "${apiName}Api dio error",error:e,stacktrace:s,message:e.toString(),);
      return $modelName(status: false,message: kConnectionErrorMessage,data:null);
    } catch (e, ) {
      AppLogger.printExceptionLog(name: "${apiName}Api error",error:e,stacktrace:s,message:e.toString(),);
      return $modelName(status: false,message: kSomethingError,data:null);
    }
  }
}

''';
  }

  String createAppLogger() {
    return '''
import 'dart:developer';

import 'package:flutter/foundation.dart';

class AppLogger{
static void printMessageLog({
  String name = 'App Log',
  String? message,
}) {
  if (kDebugMode) {
    log(
      '\n${"\$message"}\n',
      name: '--> ${"\$name"}',
    );
  }
}

static void printUrlLog({
  String name = 'App Url Log',
  String? url,
  Object? requestBody,
  Object? headers,
  Object? response,
}) {
  if (kDebugMode) {
    log(
      "\nURL --> ${"\$url"}\nHeaders --> ${"\${headers.toString()}"}\nRequest --> ${"\${requestBody.toString()}"}\nResponse --> ${"\${response.toString()}"}",
      name: '--> ${"\$name"}',
    );
  }
}

static void printExceptionLog({
  String name = 'App Exception',
  Object? error,
  StackTrace? stackTrace,
  String? message,
}) {
  if (kDebugMode) {
    log(
      message ?? 'No Message',
      stackTrace: stackTrace,
      error: error,
      name: '--> ${"\$name"}',
    );
  }
}
}
''';
  }
}
