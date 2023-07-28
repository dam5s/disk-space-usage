import 'package:intl/intl.dart';

class DiskItemPresenter {
  static String sizeText(int bytes) {
    const oneKB = 1024;
    const oneMB = oneKB * 1024;
    const oneGB = oneMB * 1024;
    final formatter = NumberFormat('###.0#', 'en_US');

    return switch (bytes) {
      _ when bytes > oneGB => '${formatter.format(bytes / oneGB)} GB',
      _ when bytes > oneMB => '${formatter.format(bytes / oneMB)} MB',
      _ when bytes > oneKB => '${formatter.format(bytes / oneKB)} KB',
      _ => '$bytes B',
    };
  }
}
