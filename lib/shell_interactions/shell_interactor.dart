import 'package:cli_creator/logger/logger.dart';
import 'package:process_run/cmd_run.dart';

class ShellInteractor {
  final logger = ConsoleLogger();

  Future<bool> createProject({required String name, String? org}) async {
    logger.warning("Project creating.....");
    final shellCommand =
        "flutter create $name ${org != null ? "--org $org" : ""}";
    try {
      await run(
        shellCommand,
        runInShell: true,
      );
      return true;
    } catch (e, s) {
      logger.warning(e.toString());
      logger.error(s.toString());
    }
    return false;
  }

  Future<bool> addDependency({required String dependency}) async {
    final shellCommand = "flutter pub add $dependency";
    try {
      await run(
        shellCommand,
        runInShell: true,
      );
      return true;
    } catch (e, s) {
      logger.warning(e.toString());
      logger.error(s.toString());
    }
    return false;
  }
}
