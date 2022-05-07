# YZ Shared preferences plugin

A plugin modified basing on [shared_preferences](https://github.com/flutter/plugins/tree/main/packages/shared_preferences)

User the special NSUserDefaults on iOS and macOS, SharedPreferences on Android instead of default.
不同于 [shared_preferences](https://github.com/flutter/plugins/tree/main/packages/shared_preferences)，本插件并没有使用默认的存储空间，防止默认的存储空间因为共用的原因太过庞大。

## Usage
To use this plugin, add `yshared_preferences` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:yshared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
      child: RaisedButton(
        onPressed: _incrementCounter,
        child: Text('Increment Counter'),
        ),
      ),
    ),
  ));
}

_incrementCounter() async {
  YSharedPreferences prefs = await YSharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  await prefs.setInt('counter', counter);
}
```

### Testing

You can populate `YSharedPreferences` with initial values in your tests by running this code:

```dart
YSharedPreferences.setMockInitialValues (Map<String, dynamic> values);
```
