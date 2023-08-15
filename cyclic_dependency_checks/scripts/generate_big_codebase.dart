import 'dart:io';
import 'dart:math';

void main() async {
  const alphabet = 'abcdefghijklmnopqrstuvwxyz';

  final letters = List.generate(
    alphabet.length,
    (i) => alphabet.substring(i, i + 1),
  );

  final packagePath = 'test_resources/example_big_codebase';

  String randomLetter() => letters[Random().nextInt(letters.length - 1)];

  final libDir = Directory('$packagePath/lib');
  if (await libDir.exists()) {
    await libDir.delete(recursive: true);
  }

  for (final letter1 in letters) {
    for (final letter2 in letters) {
      var dirPath = '$packagePath/lib/$letter1/$letter2';
      var filePath = '$dirPath/file.dart';

      await Directory(dirPath).create(recursive: true);

      await File(filePath).writeAsString(
        "import 'package:example_big_codebase/${randomLetter()}/${randomLetter()}/file.dart';\n"
        "import 'package:example_big_codebase/${randomLetter()}/${randomLetter()}/file.dart';\n",
      );
    }
  }
}
