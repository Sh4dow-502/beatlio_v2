// import 'package:beatlio_v2/provider/user_provider.dart';
// import 'package:beatlio_v2/screens/home_screen/home_screen.dart';
// import 'package:beatlio_v2/screens/login_screen/login_screen.dart';
// import 'package:beatlio_v2/screens/metronome_screen/metronome_screen.dart';
// import 'package:beatlio_v2/screens/settings_screen/settings_screen.dart';
// import 'package:beatlio_v2/screens/stats_screen/stats_screen.dart';
// import 'package:flutter/cupertino.dart' show CupertinoIcons;
// import 'package:provider/provider.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class RootScreen extends StatefulWidget {
//   const RootScreen({super.key});

//   @override
//   State<RootScreen> createState() => _RootScreenState();
// }

// class _RootScreenState extends State<RootScreen> {
//   Key? selected = const ValueKey(0);

//   NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
//   NavigationLabelType labelType = NavigationLabelType.none;
//   bool customButtonStyle = true;
//   bool expanded = true;

//   NavigationItem buildButton(String label, IconData icon, Key key) {
//     return NavigationItem(
//       key: key,
//       style: customButtonStyle
//           ? const ButtonStyle.muted(density: ButtonDensity.icon)
//           : null,
//       selectedStyle: customButtonStyle
//           ? const ButtonStyle.fixed(density: ButtonDensity.icon)
//           : null,
//       label: Text(label, style: TextStyle(fontSize: 11)),
//       child: Icon(icon, size: 22),
//     );
//   }

//   final screens = [
//     HomeScreen(),
//     MetronomeScreen(),
//     StatsScreen(),
//     SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final user = context.select((UserProvider p) => p.user);

//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 600),
//       switchInCurve: Curves.easeInOutCubic,
//       switchOutCurve: Curves.easeInOutCubic,
//       transitionBuilder: (Widget child, Animation<double> animation) {
//         // Un efecto de desvanecimiento elegante
//         return FadeTransition(opacity: animation, child: child);
//       },
//       child: user == null
//           ? const LoginScreen(key: ValueKey('login'))
//           : Scaffold(
//               key: const ValueKey('app_root'),
//               floatingFooter: true,
//               footers: [
//                 // La barra de navegación aparece suavemente desde abajo
//                 _AnimateInItem(
//                   delay: const Duration(milliseconds: 150),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Divider(),
//                       NavigationBar(
//                         surfaceBlur: 3,
//                         alignment: NavigationBarAlignment.spaceBetween,
//                         labelType: NavigationLabelType.all,
//                         expanded: true,
//                         onSelected: (key) {
//                           setState(() {
//                             selected = key;
//                           });
//                         },
//                         selectedKey: selected,
//                         children: [
//                           buildButton(
//                             "Inicio",
//                             BootstrapIcons.house,
//                             const ValueKey(0),
//                           ),
//                           buildButton(
//                             "Metrónomo",
//                             CupertinoIcons.metronome,
//                             const ValueKey(1),
//                           ),
//                           buildButton(
//                             "Estadísticas",
//                             LucideIcons.chartSpline,
//                             const ValueKey(2),
//                           ),
//                           buildButton(
//                             "Ajustes",
//                             LucideIcons.settings2,
//                             const ValueKey(3),
//                           ),
//                         ],
//                       ),
//                       Container(height: 8),
//                     ],
//                   ),
//                 ),
//               ],
//               // El contenido central tiene su propia animación de entrada
//               child: _AnimateInItem(
//                 delay: const Duration(milliseconds: 50),
//                 child: IndexedStack(
//                   index: selected != null ? (selected as ValueKey).value : 0,
//                   children: screens,
//                 ),
//               ),
//             ),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   final user = context.select((UserProvider p) => p.user);
//   //   if (user == null) {
//   //     return LoginScreen();
//   //   }
//   //   return Scaffold(
//   //     floatingFooter: true,
//   //     footers: [
//   //       Divider(),
//   //       NavigationBar(
//   //         surfaceBlur: 3,
//   //         alignment: NavigationBarAlignment.spaceBetween,
//   //         labelType: NavigationLabelType.all,
//   //         expanded: true,
//   //         onSelected: (key) {
//   //           setState(() {
//   //             selected = key;
//   //           });
//   //         },
//   //         selectedKey: selected,
//   //         children: [
//   //           buildButton("Inicio", BootstrapIcons.house, const ValueKey(0)),
//   //           buildButton(
//   //             "Metrónomo",
//   //             CupertinoIcons.metronome,
//   //             const ValueKey(1),
//   //           ),
//   //           buildButton(
//   //             "Estadísticas",
//   //             LucideIcons.chartSpline,
//   //             const ValueKey(2),
//   //           ),
//   //           buildButton("Ajustes", LucideIcons.settings2, const ValueKey(3)),
//   //         ],
//   //       ),
//   //       Container(height: 8),
//   //     ],
//   //     child: IndexedStack(
//   //       index: selected != null ? (selected as ValueKey).value : 0,
//   //       children: screens,
//   //     ),
//   //   );
//   // }
// }

// class _AnimateInItem extends StatelessWidget {
//   final Widget child;
//   final Duration delay;

//   const _AnimateInItem({required this.child, this.delay = Duration.zero});

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 700),
//       curve: Curves.bounceIn, // Curva custom (Ultra Smooth Out)
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(
//               0,
//               20 * (1 - value),
//             ), // Desplazamiento sutil hacia arriba
//             child: child,
//           ),
//         );
//       },
//       child: child,
//     );
//   }
// }
import 'package:beatlio_v2/provider/user_provider.dart';
import 'package:beatlio_v2/screens/home_screen/home_screen.dart';
import 'package:beatlio_v2/screens/login_screen/login_screen.dart';
import 'package:beatlio_v2/screens/metronome_screen/metronome_screen.dart';
import 'package:beatlio_v2/screens/settings_screen/settings_screen.dart';
import 'package:beatlio_v2/screens/stats_screen/stats_screen.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:provider/provider.dart';
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
      label: Text(label, style: const TextStyle(fontSize: 11)),
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
    final user = context.select((UserProvider p) => p.user);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      // EVITA EL PARPADEO: Mantiene el tamaño y superposición correcta de ambas pantallas
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Una transición cruzada de opacidad impecable y sutil escala
        final scale = Tween<double>(begin: 0.98, end: 1.0).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
      child: user == null
          ? const LoginScreen(key: ValueKey('login'))
          : Scaffold(
              key: const ValueKey('app_root'),
              floatingFooter: true,
              footers: [
                _AnimateInItem(
                  // Un retraso muy pequeño para que la barra aparezca justo después del fondo
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(),
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
                          buildButton(
                            "Inicio",
                            BootstrapIcons.house,
                            const ValueKey(0),
                          ),
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
                          buildButton(
                            "Ajustes",
                            LucideIcons.settings2,
                            const ValueKey(3),
                          ),
                        ],
                      ),
                      Container(height: 8),
                    ],
                  ),
                ),
              ],
              child: _AnimateInItem(
                delay: Duration.zero,
                child: IndexedStack(
                  index: selected != null ? (selected as ValueKey).value : 0,
                  children: screens,
                ),
              ),
            ),
    );
  }
}

class _AnimateInItem extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const _AnimateInItem({required this.child, this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      // CAMBIADO: Usamos easeOutCubic para una desaceleración ultra fluida sin rebotes extraños
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            // El desplazamiento ahora es mínimo (12px) para que se sienta fino y no tosco
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
