abstract interface class KeyValueEntity<T> {
  T get();
  Future<void> set(T value);
  Future<void> delete();
  Stream<T> watch();
}
