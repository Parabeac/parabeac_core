import 'dart:io';

class Proxy {
  String currentDirectory = Directory.current.path;

  String get proxyPath {
    var proxyPath = '$currentDirectory/lib/helperScripts/shell-proxy.sh';

    return proxyPath;
  }
}
