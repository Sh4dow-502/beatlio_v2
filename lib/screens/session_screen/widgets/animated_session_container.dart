// import 'package:flutter/material.dart';

// class AnimatedSessionContainer extends StatelessWidget {
//   final String animationKey;
//   final Widget child;
//   final bool isRest;

//   const AnimatedSessionContainer({
//     super.key,
//     required this.animationKey,
//     required this.child,
//     required this.isRest,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 620),
//       reverseDuration: const Duration(milliseconds: 360),
//       switchInCurve: Curves.easeOutQuart,
//       switchOutCurve: Curves.easeInCubic,
//       layoutBuilder: (currentChild, previousChildren) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             ...previousChildren,
//             currentChild ?? const SizedBox.shrink(),
//           ],
//         );
//       },
//       transitionBuilder: (child, animation) {
//         final fade = CurvedAnimation(
//           parent: animation,
//           curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
//           reverseCurve: Curves.easeIn,
//         );
//         final scale =
//             TweenSequence<double>([
//               TweenSequenceItem(
//                 tween: Tween<double>(
//                   begin: isRest ? 0.82 : 0.8,
//                   end: 1.03,
//                 ).chain(CurveTween(curve: Curves.easeOutCubic)),
//                 weight: 72,
//               ),
//               TweenSequenceItem(
//                 tween: Tween<double>(
//                   begin: 1.03,
//                   end: 1.0,
//                 ).chain(CurveTween(curve: Curves.easeOutCubic)),
//                 weight: 28,
//               ),
//             ]).animate(
//               CurvedAnimation(
//                 parent: animation,
//                 curve: Curves.easeOutQuart,
//                 reverseCurve: Curves.easeInCubic,
//               ),
//             );
//         final slide =
//             Tween<Offset>(
//               begin: isRest
//                   ? const Offset(0.0, 0.085)
//                   : const Offset(0.0, 0.11),
//               end: Offset.zero,
//             ).animate(
//               CurvedAnimation(
//                 parent: animation,
//                 curve: Curves.easeOutCubic,
//                 reverseCurve: Curves.easeInCubic,
//               ),
//             );
//         final drift = Tween<double>(begin: isRest ? -0.015 : -0.02, end: 0)
//             .animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
//             );

//         return FadeTransition(
//           opacity: fade,
//           child: SlideTransition(
//             position: slide,
//             child: ScaleTransition(
//               scale: scale,
//               child: AnimatedBuilder(
//                 animation: drift,
//                 child: child,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, drift.value * 1000),
//                     child: child,
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//       child: KeyedSubtree(key: ValueKey(animationKey), child: child),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class AnimatedSessionContainer extends StatelessWidget {
//   final String animationKey;
//   final Widget child;
//   final bool isRest;

//   const AnimatedSessionContainer({
//     super.key,
//     required this.animationKey,
//     required this.child,
//     required this.isRest,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 550),
//       reverseDuration: const Duration(milliseconds: 250),
//       switchInCurve: Curves.easeOutCubic,
//       switchOutCurve: Curves.easeInCubic,
//       layoutBuilder: (currentChild, previousChildren) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             ...previousChildren,
//             if (currentChild != null) currentChild,
//           ],
//         );
//       },
//       transitionBuilder: (child, animation) {
//         final opacity = Tween<double>(begin: 0, end: 1).animate(
//           CurvedAnimation(
//             parent: animation,
//             curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
//           ),
//         );

//         final scale = TweenSequence<double>([
//           TweenSequenceItem(
//             tween: Tween(
//               begin: 0.94,
//               end: 1.02,
//             ).chain(CurveTween(curve: Curves.easeOutCubic)),
//             weight: 70,
//           ),
//           TweenSequenceItem(
//             tween: Tween(
//               begin: 1.02,
//               end: 1.0,
//             ).chain(CurveTween(curve: Curves.easeOut)),
//             weight: 30,
//           ),
//         ]).animate(animation);

//         final translate = Tween<double>(begin: 12, end: 0).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
//         );

//         return AnimatedBuilder(
//           animation: animation,
//           child: child,
//           builder: (context, child) {
//             return Opacity(
//               opacity: opacity.value,
//               child: Transform.translate(
//                 offset: Offset(0, translate.value),
//                 child: Transform.scale(scale: scale.value, child: child),
//               ),
//             );
//           },
//         );
//       },
//       child: KeyedSubtree(key: ValueKey(animationKey), child: child),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AnimatedSessionContainer extends StatefulWidget {
  final String animationKey;
  final Widget child;
  final bool isRest;

  const AnimatedSessionContainer({
    super.key,
    required this.animationKey,
    required this.child,
    required this.isRest,
  });

  @override
  State<AnimatedSessionContainer> createState() =>
      _AnimatedSessionContainerState();
}

class _AnimatedSessionContainerState extends State<AnimatedSessionContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.94,
          end: 1.03,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.03,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedSessionContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationKey != widget.animationKey) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Transform.scale(scale: _scale.value, child: child);
      },
    );
  }
}
