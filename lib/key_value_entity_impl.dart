import 'package:key_value_storage/key_value_storage.dart';

class KeyValueEntityImpl<T> implements KeyValueEntity<T> {
  final KeyValueStorage storage;
  final String key;
  final FromJson<T>? fromJson;
  final ToJson<T>? toJson;
  final CreateDefault<T>? createDefault;

  const KeyValueEntityImpl(
    this.storage, {
    required this.key,
    this.fromJson,
    this.toJson,
    this.createDefault,
  });

  @override
  Future<void> delete() {
    return storage.delete(key);
  }

  @override
  T get() {
    return storage.get(key, fromJson: fromJson, createDefault: createDefault);
  }

  @override
  Future<void> set(T value) {
    return storage.set(key, value, toJson: toJson);
  }

  @override
  Stream<T> watch() {
    return storage.watch(key, fromJson: fromJson, createDefault: createDefault);
  }
}
