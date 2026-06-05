import 'package:beatlio_v2/provider/home_session_provider.dart';
import 'package:beatlio_v2/screens/home_screen/components/card_serie/card_session.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/new_session_screen.dart';
import 'package:beatlio_v2/screens/session_details_screen/session_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeSessionProvider>().loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      headers: [
        AppBar(
          title: Text("Beatlio").semiBold(),
          leading: [
            IconButton(
              icon: Icon(LucideIcons.menu),
              variance: ButtonStyle.textIcon(),
              density: ButtonDensity.compact,
            ),
          ],
          trailing: [
            IconButton(
              icon: Icon(LucideIcons.search),
              variance: ButtonStyle.textIcon(),
            ),
            Avatar(
              initials: Avatar.getInitials("santos"),
              backgroundColor: colors.primary,
              size: 45,
            ),
          ],
          leadingGap: 0,
          trailingGap: 10,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        // Divider(),
      ],
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Hi ").x2Large().bold(),
                Text("Santos").bold(color: colors.primary).x2Large(),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.swap_vert),
                  variance: ButtonStyle.textIcon(),
                  density: ButtonDensity.compact,
                ),
                // Text('Tus sesiones').xLarge().bold(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Consumer<HomeSessionProvider>(
                builder: (context, provider, child) {
                  final sessions = provider.sessions;

                  if (sessions.isEmpty) {
                    return Center(child: Text("No hay sesiones guardadas"));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 13),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SessionDetailsScreen(session: session),
                              ),
                            ),
                            child: CardSession(
                              name: session.name,
                              totalTime: session.totalTime(),
                              totalExercises: session.totalExercises(),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SessionDetailsScreen(session: session),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 110,
              right: 0,
              child: PrimaryButton(
                leading: Icon(BootstrapIcons.plus),
                child: Text('Sesión'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NewSessionScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
