import 'dart:convert';

import 'package:key_value_storage/key_value_storage_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageImpl implements KeyValueStorage {
  late SharedPreferences preferences;
  final controller = BehaviorSubject<Map<String, dynamic>>.seeded({});

  @override
  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> dispose() async {
    await controller.close();
  }

  @override
  Future<void> clear() async {
    await preferences.clear();
    controller.sink.add({});
  }

  @override
  Future<void> delete(String key) async {
    await preferences.remove(key);
    controller.sink.add({...controller.value}..remove(key));
  }

  @override
  T get<T>(
    String key, {
    T Function(dynamic data)? fromJson,
    CreateDefault<T>? createDefault,
  }) {
    final data = preferences.get(key);
    if (data == null) {
      return createDefault?.call() as T;
    }
    if (fromJson != null) {
      return fromJson(jsonDecode(data as String));
    }
    return data as T;
  }

  @override
  Future<void> set<T>(String key, T value, {Function(T value)? toJson}) async {
    await switch (value) {
      int() => preferences.setInt(key, value),
      bool() => preferences.setBool(key, value),
      double() => preferences.setDouble(key, value),
      String() => preferences.setString(key, value),
      List<String>() => preferences.setStringList(key, value),
      _ => preferences.setString(key, jsonEncode(toJson!(value))),
    };
    controller.sink.add({...controller.value, key: value});
  }

  @override
  Stream<T> watch<T>(
    String key, {
    T Function(dynamic data)? fromJson,
    CreateDefault<T>? createDefault,
  }) {
    return controller.stream
        .distinct((previous, next) => previous[key] == next[key])
        .map((event) => fromJson?.call(event) ?? createDefault?.call() as T);
  }
}
