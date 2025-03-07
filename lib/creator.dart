import 'package:cli_creator/features/api_initializer/api_intializer.dart';
import 'package:cli_creator/features/bloc_initializer/bloc_initializer.dart';
import 'package:cli_creator/features/project_initializer/project_initializer.dart';

class Creator {
  Future<int> findCommand(String command) async {
    switch (command) {
      case "create --project":
        await ProjectInitializer().create();
        return 0;
      case "create --bloc -c":
        await BlocInitializer().createBlocInCore();
        return 0;
      case "create --bloc -f":
        await BlocInitializer().createBlocInFeature();
        return 0;
      case "create --api -c":
        await ApiIntializer().createApiInCore();
        return 0;
      case "create --api -f":
        await ApiIntializer().createApiInFeature();
        return 0;
      default:
        return 1;
    }
  }
}
