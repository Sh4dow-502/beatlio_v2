import 'package:beatlio_v2/db/objectbox_handler.dart';
import 'package:beatlio_v2/provider/excercise_provider.dart';
import 'package:beatlio_v2/provider/home_session_provider.dart';
import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/provider/metronome_provider.dart';
import 'package:beatlio_v2/provider/metronome_sound_provider.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/provider/serie_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:beatlio_v2/screens/root_screen/root_screen.dart';
import 'package:beatlio_v2/services/audio_service.dart';
import 'package:beatlio_v2/services/new_session_service.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

late ObjectBox objectbox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  final audioService = AudioService();
  await audioService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<AudioService>.value(value: audioService),
        Provider(create: (_) => NewSessionService(objectbox.store)),
        ChangeNotifierProvider(create: (_) => ExcerciseProvider()),
        ChangeNotifierProvider(create: (_) => MetronomeProvider(audioService)),
        ChangeNotifierProvider(create: (_) => SerieProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              HomeSessionProvider(context.read<NewSessionService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NewSessionProvider(context.read<NewSessionService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => MetronomeSoundProvider(audioService),
        ),
        ChangeNotifierProvider(
          create: (_) => MetronomeGlobalProvider(audioService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: "Beatlio v2",
      home: const RootScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorSchemes.darkZinc.indigo,
        radius: 1.3,
        density: Density.defaultDensity,
        surfaceOpacity: 0.92,
        surfaceBlur: 5,
        typography: Typography.geist(),
      ),
    );
  }
}
