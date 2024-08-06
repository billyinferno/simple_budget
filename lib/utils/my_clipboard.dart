import 'package:simple_budget/_index.g.dart';
import 'package:super_clipboard/super_clipboard.dart';

class MyClipboard {
  static SystemClipboard? _clipboard;
  static DataWriterItem? _item;

  static Future<void> copyToClipboard({required String text}) async {
    // initialize clipboard if null
    _clipboard ??= SystemClipboard.instance;

    if (_clipboard != null) {
      // we can access the clipboard, copy the text to the clipboard
      _item ??= DataWriterItem();
      if (_item != null) {
        _item!.add(Formats.plainText(text));
        await _clipboard!.write([_item!]).onError((error, stackTrace) {
          Log.error(
            message: 'Unable to write on the clipboard',
            error: error,
            stackTrace: stackTrace,
          );
          throw Exception('Unable to write on the clipboard');
        },);
      }
      else {
        Log.error(message: 'Unable to create item writer');
        throw Exception('Unable to create item writer');
      }
    }
    else {
      Log.error(message: 'Error when accessing clipboard');
      throw Exception('Error when accessing clipboard');
    }
  }
}