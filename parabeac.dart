import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';

ArgResults argResults;

// ignore: always_declare_return_types
main(List<String> args) async {
  var arguments = <String>['lib/main.dart'];

  //sets up parser
  //wil set the hide option for help flag to true to
  //prevent the help usage from being printed twice in console
  ///sets up parser
  final parser = ArgParser()
    ..addOption('out', help: 'The output path', valueHelp: 'path', abbr: 'o')
    ..addOption('project-name', help: 'The name of the project', abbr: 'n')
    ..addOption(
      'config-path',
      help: 'Path of the configuration file',
      abbr: 'c',
      defaultsTo: p.setExtension(
          p.join('lib', 'configurations', 'configurations'), '.json'),
    )
    // '${p.setExtension(p.join('lib/configurations/', 'configurations'), '.json')}')
    ..addOption('fig', help: 'The ID of the figma file', abbr: 'f')
    ..addOption('figKey', help: 'Your personal API Key', abbr: 'k')
    ..addOption(
      'pbdl-in',
      help:
          'Takes in a Parabeac Design Logic (PBDL) JSON file and exports it to a project',
    )
    ..addOption('oauth', help: 'Figma OAuth Token')
    ..addOption(
      'folderArchitecture',
      help: 'Folder Architecture type to use.',
      allowedHelp: {
        'domain':
            'Default Option. Generates a domain-layered folder architecture.'
      },
    )
    ..addOption(
      'componentIsolation',
      help: 'Component Isolation configuration to use.',
      allowedHelp: {
        'widgetbook': 'Default option. Use widgetbook for component isolation.',
        'dashbook': 'Use dashbook for component isolation.',
        'none': 'Do not use any component isolation packages.',
      },
    )
    ..addOption(
      'project-type',
      help: 'Type of project to generate.',
      allowedHelp: {
        'screens': 'Default Option. Generate a full app.',
        'components': 'Generate a component package.',
        'themes': 'Generate theme information.',
      },
    )
    ..addFlag('help',
        help: 'Displays this help information.', abbr: 'h', negatable: false)
    ..addFlag(
      'export-pbdl',
      help: 'This flag outputs Parabeac Design Logic (PBDL) in JSON format.',
      negatable: false,
    )
    ..addFlag('exclude-styles',
        help: 'If this flag is set, it will exclude output styles document');
  argResults = parser.parse(args);

  //Check if no args passed or only -h/--help passed
  //stops the program after printing the help for both the
  //main parabeac arguments and the the parabeac egg arguments
  if (argResults['help']) {
    print('''
Common commands:

${parser.usage}
    ''');
    exit(0);
  }

  arguments.addAll(argResults.arguments);

  var install = await Process.start('bash', [
    '${Directory.current.path}/pb-scripts/install.sh',
  ]);

  await stdout.addStream(install.stdout);
  await stderr.addStream(install.stderr);
  var exitCode = await install.exitCode;
  if (exitCode != 0) {
    print('install.sh finished with exit code $exitCode');
  }

  /// To Download and merge the plugins on the codebase
  var result = await Process.start(
    'bash',
    [
      '${Directory.current.path}/pb-scripts/merge-plugins.sh',
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
