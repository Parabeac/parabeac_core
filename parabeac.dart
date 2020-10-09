import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

ArgResults argResults;

// ignore: always_declare_return_types
main(List<String> args) async {
  var arguments = <String>['lib/main.dart'];

  //sets up parser
  //wil set the hide option for help flag to true to
  //prevent the help usage from being printed twice in console
  final parser = ArgParser()
    ..addOption('path',
        help: 'Path to the design file', valueHelp: 'path', abbr: 'p')
    ..addOption('out', help: 'The output path', valueHelp: 'path', abbr: 'o')
    ..addOption('project-name',
        help: 'The name of the project', abbr: 'n', defaultsTo: 'temp')
    ..addOption('config-path',
        help: 'Path of the configuration file',
        abbr: 'c',
        defaultsTo: 'default:lib/configurations/configurations.json')
    ..addFlag('help',
        help: 'Displays this help information.', abbr: 'h', negatable: false)
    ..addOption('url',
        help: 'S3 bucket link to download and install Parabeac Eggs', abbr: 'u')
    ..addOption('key', help: 'key for S3 bucket account', abbr: 'k')
    ..addOption('secret-key', help: 'S3 secret key', abbr: 's');

  argResults = parser.parse(args);

  //Check if no args passed or only -h/--help passed
  //stops the program after printing the help for both the
  //main parabeac arguments and the the parabeac egg arguments
  if (argResults['help'] || argResults.arguments.isEmpty) {
    print('''
Common commands:

${parser.usage}
    ''');
    exit(0);
  }

  var url = argResults['url'];
  var key = argResults['key'];
  var sKey = argResults['secret-key'];

  if (argResults.arguments.contains('-p') ||
      argResults.arguments.contains('--path')) {
    arguments.addAll(argResults.arguments);
  }

  /// To install parabeac core
  var install = Process.start(
    'bash',
    [
      '${Directory.current.path}/pb-scripts/install.sh',
    ],
  ).then((process) {
    stdout.addStream(process.stdout);
    process.exitCode.then((exitCode) {
      if (exitCode != 0) {
        print('exit code: $exitCode');
      }
    });
  });
  await install;

  /// To Download and merge the plugins on the codebase
  var result = await Process.start(
    'bash',
    [
      '${Directory.current.path}/pb-scripts/merge-plugins.sh',
      '$url',
      '$sKey',
      '$key',
    ],
  );

  await for (var event in result.stdout.transform(utf8.decoder)) {
    print(event);
  }
  await for (var event in result.stderr.transform(utf8.decoder)) {
    print(event);
  }

  /// To run parabeac-core
  var parabeaccore = await Process.start(
    'dart',
    arguments,
  );
  await for (var event in parabeaccore.stdout.transform(utf8.decoder)) {
    print(event);
  }
  await for (var event in parabeaccore.stderr.transform(utf8.decoder)) {
    print(event);
  }
}
