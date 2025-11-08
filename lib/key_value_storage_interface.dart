typedef FromJson<T> = T Function(dynamic json);
typedef ToJson<T> = dynamic Function(T data);
typedef CreateDefault<T> = T Function();

abstract interface class KeyValueStorage {
  Future<void> init();

  Future<void> dispose();

  Future<void> clear();

  Future<void> set<T>(String key, T value, {ToJson<T>? toJson});

  Future<void> delete(String key);

  T get<T>(
    String key, {
    FromJson<T>? fromJson,
    CreateDefault<T>? createDefault,
  });

  Stream<T> watch<T>(
    String key, {
    FromJson<T>? fromJson,
    CreateDefault<T>? createDefault,
  });
}
