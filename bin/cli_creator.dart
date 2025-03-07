import 'package:cli_creator/creator.dart';
import 'package:cli_creator/logger/logger.dart';
import 'package:dcli/dcli.dart';

void main(List<String> arguments) async {
  print('Starting CREATOR...');
  try {
    if (arguments.isEmpty) {
      print(blue("No command found"));
      //printUsage(argParser);
      return;
    }
    final exitCode = await Creator().findCommand(arguments.join(' '));
    if(exitCode == 1){
    ConsoleLogger().error("${arguments.join(' ')} command not found");
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
  } catch (e, s) {
    ConsoleLogger().error(e.toString());
    ConsoleLogger().error(s.toString());
  }
}
