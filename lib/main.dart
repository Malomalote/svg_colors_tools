import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/home_page.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(600, 800),
    center: true,
    backgroundColor: Colors.transparent,
    title: 'Svg Colors Tools',
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    // maximumSize: Size(800,1000)
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
 runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(darkThemeProvider);
    const flexScheme = FlexScheme.verdunHemlock;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',

      theme: isDarkTheme
          ? FlexThemeData.dark(scheme: flexScheme)
          : FlexThemeData.light(scheme: flexScheme),

      // ThemeData.light() : ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
