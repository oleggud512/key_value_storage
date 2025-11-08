# Key Value Storage Wrapper

A lightweight, type-safe wrapper around Flutter’s `shared_preferences`, designed to make persistent key-value storage simple, reactive, and structured.

This package introduces two key concepts: `KeyValueStorage` and `KeyValueEntity<T>`, allowing you to define strongly-typed storage entities and observe changes in real-time.

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  key_value_storage: <latest_version>
```

Then run:

```
flutter pub get
```

---

## 🚀 Usage

### 1. Define Your Interface

Create an interface that defines your app-specific storage structure:

```dart
import 'package:key_value_storage/key_value_storage.dart';
import 'package:trn/app/app.dart';

abstract interface class AppKeyValueStorage {
  KeyValueEntity<AppSettings> get appSettings;
}
```

This interface acts as a contract for what keys and data types are available in your app’s persistent storage.

---

### 2. Implement the Interface

Create an implementation that binds each entity to an underlying `KeyValueStorage` instance:

```dart
import 'package:key_value_storage/key_value_storage.dart';
import 'package:trn/app/entities/app_settings.dart';
import 'app_key_value_storage_interface.dart';

class AppKeyValueStorageImpl implements AppKeyValueStorage {
  final KeyValueStorage storage;

  AppKeyValueStorageImpl(this.storage);

  @override
  late KeyValueEntity<AppSettings> appSettings = KeyValueEntityImpl(
    storage,
    key: 'appSettings',
    fromJson: (json) => AppSettings.fromJson(json),
    toJson: (settings) => settings.toJson(),
    createDefault: () => AppSettings(),
  );
}
```

This creates a strongly-typed persistent store for your app’s settings that can be easily retrieved, updated, and observed.

---

### 3. Using Your Storage

You can now read, write, delete, or observe your stored data:

```dart
final storage = AppKeyValueStorageImpl(yourStorageInstance);

// Read current settings
final settings = storage.appSettings.get();

// Update settings
await storage.appSettings.set(updatedSettings);

// Delete settings
await storage.appSettings.delete();

// Listen to changes
storage.appSettings.watch().listen((value) {
  print('Settings changed: $value');
});
```

---

## 🔑 Core Interfaces

### `KeyValueEntity<T>`

Represents a single stored entity of type `T`.

```dart
abstract interface class KeyValueEntity<T> {
  T get();
  Future<void> set(T value);
  Future<void> delete();
  Stream<T> watch();
}
```

---

### `KeyValueStorage`

Defines the core key-value storage behavior.

```dart
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
```

---

## 🧩 Why Use This Wrapper?

- **Type Safety** – No more dynamic map lookups or type casting.
- **Reactivity** – Use streams to respond to storage changes in real-time.
- **Abstraction** – Cleanly separate storage definitions from app logic.
- **Testability** – Easy to mock and test using interfaces.

---

## 🧠 Example Use Case

Store app preferences, authentication data, or feature flags in a reactive, structured way without direct dependency on `shared_preferences`.

---

## 🧰 Extending the Wrapper

You can implement your own `KeyValueStorage` backend using Hive, SQLite, or even cloud-based storage by following the same interface.
