import 'package:appxiom_flutter/appxiom_flutter.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Ax.init(
    '01M4RE024278X15PPEW0E6W3ZC',
    'ffd95e8aa319f613f5b4c4e82c5ad62b0fa4a56eebddf2e83143a11db5257e01',
  );
  // Ax.initIOS(); // keys come from Info.plist

  AxApp.run(child: const MyApp(), screenName: 'App', widgetName: 'MyApp');
}
