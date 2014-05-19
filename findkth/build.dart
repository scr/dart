
import 'package:chrome/build/build.dart';
import 'package:polymer/builder.dart';

/**
 * This build script watches for changes to any .dart files and copies the root
 * packages directory to the app/packages directory. This works around an issue
 * with Chrome apps and symlinks and allows you to use pub with Chrome apps.
 */
void main(List<String> args) {
  build(entryPoints: ['web/domparser.html'],
        options: parseOptions(args));

  copyPackages(new Directory('web'));
}
