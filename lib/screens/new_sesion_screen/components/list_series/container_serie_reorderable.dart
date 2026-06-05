import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/custom_alert_dialog.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_serie/form_new_serie.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/list_series/container_serie.dart';
import 'package:beatlio_v2/ui/components/icon_drag.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:flutter/material.dart' hide showDialog;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class ContainerSerieReorderable extends StatelessWidget {
  final Serie serie;
  final int index;
  final bool reorderMode;

  const ContainerSerieReorderable({
    super.key,
    required this.serie,
    required this.index,
    this.reorderMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: reorderMode
          ? Row(
              children: [
                Expanded(
                  child: ContainerSerie(serie: serie, index: index),
                ),
                const SizedBox(width: 8),
                ReorderableDelayedDragStartListener(
                  index: index,
                  child: IconDrag(),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: ReorderableDelayedDragStartListener(
                    index: index,
                    child: ContainerSerie(serie: serie, index: index),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Editar serie',
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          openMaterialSheet(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      5,
                                ),
                                child: FormNewSerie(
                                  isEditing: true,
                                  serie: serie,
                                  serieIndex: index,
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(34, 34),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          foregroundColor: Colors.white.withValues(alpha: 0.62),
                        ),
                      ),
                      const SizedBox(height: 6),
                      IconButton(
                        tooltip: 'Eliminar serie',
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
                          final result = await shadcn.showDialog<bool>(
                            context: context,
                            builder: (context) => const CustomAlertDialog(),
                          );
                          if (result != true) return;
                          if (!context.mounted) return;

                          context.read<NewSessionProvider>().removeSerie(index);
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 16,
                        ),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(34, 34),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          foregroundColor: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
