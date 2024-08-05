import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_budget/utils/log.dart';

class LocalStorage {
  static Box<dynamic>? _box;

  static Future<void> init() async {
    if (_box == null) {
      Log.info(message: "📦Initialize Local Storage");
      await Hive.initFlutter();

      // create the box
      _box = await Hive.openBox(
        'storage',
        compactionStrategy: (entries, deletedEntries) {
          // check if the deleted entries already more or equal to 50.
          return deletedEntries >= 50;
        },
      );
    }
  }

  static Future<void> put({required String key, required String value}) async {
    // ensure _box is not null
    if (_box == null) {
      await init();
    }

    // put the value to the box
    _box!.put(key, value);
  }

  static Future<void> putList({required String key, required List<String> value}) async {
    // ensure box is not null
    if (_box == null) {
      await init();
    }

    // put the value to the box
    _box!.put(key, value);
  }

  static String get({required String key}) {
    // check if box is not  null
    if (_box != null) {
      // check if we have this key on the box
      if (_box!.containsKey(key)) {
        return (_box!.get(key));
      }
    }
    // anyhow return empty
    return '';
  }

  static List<String> getList({required String key}) {
    // check if box is not  null
    if (_box != null) {
      // check if we have this key on the box
      if (_box!.containsKey(key)) {
        return List<String>.from(_box!.get(key));
      }
    }
    // anyhow return empty
    return [];
  }

  static Future<void> delete({required String key, bool? exact}) async {
    // first ensure box is not null
    if (_box != null) {
      // do we want to do exact key delete
      bool isExact = (exact ?? true);

      if (isExact) {
        if (_box!.containsKey(key)) {
          // delete the key
          _box!.delete(key);
        }
      }
      else {
        // iterate all the keys to see if we need to delete it or not?
        Iterable<String> keys = _box!.keys as Iterable<String>;
        for(String key in keys) {
          if (key.toLowerCase().contains(key.toLowerCase())) {
            // delete this
            _box!.delete(key);
          }
        }
      }
    }
  }

  static Future<void> clear() async {
    // first ensure box is not null
    if (_box != null) {
      // get all the keys
      Iterable<String> keys = _box!.keys as Iterable<String>;
      // loop thru all the keys
      for(String key in keys) {
        // delete the key
        _box!.delete(key);
      }
    }
  }
}