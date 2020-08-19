import 'dart:io';

main(List<String> args) {
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
  var install = Process.runSync(
    'bash',
    [
      '${Directory.current.path}/pb-scripts/install.sh',
    ],
  );
  if (install.stdout == null || install.stdout.isEmpty) {
    print(install.stderr);
  } else {
    print(install.stdout);
  }

  /// To Download and merge the plugins on the codebase
  var result = Process.runSync(
    'bash',
    [
      '${Directory.current.path}/pb-scripts/merge-plugins.sh',
      '$url',
      '$sKey',
      '$key',
    ],
  );
  if (result.stdout == null || result.stdout.isEmpty) {
    print(result.stderr);
  } else {
    print(result.stdout);
  }

  /// To run parabeac-core
  var parabeaccore = Process.runSync(
    'dart',
    arguments,
  );
  if (parabeaccore.stdout == null || parabeaccore.stdout.isEmpty) {
    print(parabeaccore.stderr);
  } else {
    print(parabeaccore.stdout);
  }
}
