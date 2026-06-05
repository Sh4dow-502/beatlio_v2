import 'package:beatlio_v2/screens/home_screen/home_screen.dart';
import 'package:beatlio_v2/screens/metronome_screen/metronome_screen.dart';
import 'package:beatlio_v2/screens/settings_screen/settings_screen.dart';
import 'package:beatlio_v2/screens/stats_screen/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  Key? selected = const ValueKey(0);

  NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
  NavigationLabelType labelType = NavigationLabelType.none;
  bool customButtonStyle = true;
  bool expanded = true;

  NavigationItem buildButton(String label, IconData icon, Key key) {
    return NavigationItem(
      key: key,
      style: customButtonStyle
          ? const ButtonStyle.muted(density: ButtonDensity.icon)
          : null,
      selectedStyle: customButtonStyle
          ? const ButtonStyle.fixed(density: ButtonDensity.icon)
          : null,
      label: Text(label, style: TextStyle(fontSize: 11)),
      child: Icon(icon, size: 22),
    );
  }

  final screens = [
    HomeScreen(),
    MetronomeScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingFooter: true,
      footers: [
        Divider(),
        NavigationBar(
          surfaceBlur: 3,
          alignment: NavigationBarAlignment.spaceBetween,
          labelType: NavigationLabelType.all,
          expanded: true,
          onSelected: (key) {
            setState(() {
              selected = key;
            });
          },
          selectedKey: selected,
          children: [
            buildButton("Inicio", BootstrapIcons.house, const ValueKey(0)),
            buildButton(
              "Metrónomo",
              CupertinoIcons.metronome,
              const ValueKey(1),
            ),
            buildButton(
              "Estadísticas",
              LucideIcons.chartSpline,
              const ValueKey(2),
            ),
            buildButton("Ajustes", LucideIcons.settings2, const ValueKey(3)),
          ],
        ),
        Container(height: 8),
      ],
      child: IndexedStack(
        index: selected != null ? (selected as ValueKey).value : 0,
        children: screens,
      ),
    );
  }
}
