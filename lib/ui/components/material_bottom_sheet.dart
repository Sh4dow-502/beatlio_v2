import 'package:flutter/material.dart';

Future<T?> openMaterialSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool enableDrag = true,
  bool isDismissible = true,
  Color? barrierColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 640),
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.68),
    builder: (sheetContext) {
      final colorScheme = Theme.of(sheetContext).colorScheme;

      return Material(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
                child: builder(sheetContext),
              ),
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
