import 'dart:convert';
import 'dart:io';

main(List<String> args) async {
  List<String> arguments = ['lib/main.dart'];
  var url = '';
  var key = '';
  var sKey = '';
  for (var i = 0; i < args.length; i += 2) {
    switch (args[i]) {
      case '-url':
        url = args[i + 1];
        break;
      case '-key':
        key = args[i + 1];
        break;
      case '-Skey':
        sKey = args[i + 1];
        break;
      default:
        arguments.addAll([args[i], args[i + 1]]);
        break;
    }
  }

  /// To install parabeac core
  var install = await Process.start(
    'bash',
    [
      '${Directory.current.path}/pb-scripts/install.sh',
    ],
  );

  await for (var event in install.stdout.transform(utf8.decoder)) {
    print(event);
  }
  await for (var event in install.stderr.transform(utf8.decoder)) {
    print(event);
  }

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
