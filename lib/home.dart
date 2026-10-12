import 'package:appxiom_flutter/appxiom_flutter.dart';
import 'package:appxiom_flutter/ax_state.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends AxInitialState<MyHomePage> {
  @override
  String get stateClassName => 'MyHomePage';

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// Runs [action], catches whatever it throws and reports it to Appxiom.
  void _caught(void Function() action) {
    try {
      action();
    } catch (e, st) {
      Ax.reportError(e, st);
    }
  }

  late final Map<String, VoidCallback> _exceptionTriggers = {
    'Exception': () => _caught(() => throw Exception('Test generic exception')),
    'FormatException': () => _caught(() => int.parse('not-a-number')),
    'RangeError': () => _caught(() => <int>[1, 2, 3][10]),
    'StateError': () => _caught(() => <int>[].first),
    'TypeError': () => _caught(() {
      final Object value = 'text';
      // ignore: unnecessary_cast
      (value as int).toString();
    }),
    'Null check': () => _caught(() {
      String? value;
      value!.length;
    }),
    'UnsupportedError': () => _caught(() => List<int>.unmodifiable([1]).add(2)),
    'Timeout': () =>
        Future<void>.delayed(const Duration(seconds: 5))
            .timeout(const Duration(milliseconds: 100))
            .catchError((Object e, StackTrace st) => Ax.reportError(e, st)),
    'Custom issue': () => Ax.reportIssue(
      'MyHomePage',
      'Custom test issue',
      'Triggered from the home screen',
    ),
    // Not caught: handled by FlutterError.onError / PlatformDispatcher.
    'Uncaught (sync)': () => throw Exception('Uncaught sync exception'),
    'Uncaught (async)': () => Future<void>.delayed(
      Duration.zero,
      () => throw StateError('Uncaught async exception'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final entry in _exceptionTriggers.entries)
                  ElevatedButton(
                    onPressed: entry.value,
                    child: Text(entry.key),
                  ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
