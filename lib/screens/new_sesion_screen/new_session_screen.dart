import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/provider/home_session_provider.dart';
import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/form_new_excercise.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_serie/form_new_serie.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/list_exercises.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/list_series/list_series.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/rest_time_selector/set_rest_time_session.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/save_session_button.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/session_name_field.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
// import 'package:flutter/material.dart' as m;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class NewSessionScreen extends StatefulWidget {
  final Session? session;

  const NewSessionScreen({super.key, this.session});

  @override
  State<NewSessionScreen> createState() => _NewSessionScreenState();
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  int index = 0;
  final controller = PageController();
  bool _isFabSheetOpen = false;

  Future<void> _handleExitRequest() async {
    if (await _confirmExitIfNeeded()) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _openFabSheet() async {
    if (_isFabSheetOpen) return;

    setState(() {
      _isFabSheetOpen = true;
    });

    try {
      await openMaterialSheet(
        context: context,
        builder: (context) {
          final fabType = context.watch<NewSessionProvider>().fabType;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 5,
            ),
            child: fabType == 0 ? FormNewExcercise() : FormNewSerie(),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFabSheetOpen = false;
        });
      }
    }
  }

  Future<bool> _confirmExitIfNeeded() async {
    if (_isFabSheetOpen) {
      return false;
    }

    final provider = context.read<NewSessionProvider>();

    if (!provider.hasUnsavedChanges) {
      return true;
    }

    final action = await showDialog<_ExitAction>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cambios sin guardar').small(),
          content: Text(
            'Tienes cambios pendientes en esta sesión. ¿Qué quieres hacer?',
          ).xSmall(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, _ExitAction.cancel),
              density: ButtonDensity.dense,
              child: Text("Cancelar").xSmall(),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _ExitAction.discard),
              density: ButtonDensity.dense,
              child: Text(
                "Descartar",
              ).xSmall(color: CustomColors.red.withValues(alpha: 0.8)),
            ),
            // OutlineButton(
            //   onPressed: () => Navigator.pop(context, _ExitAction.cancel),
            //   density: ButtonDensity.dense,
            //   child: Text('Cancelar').xSmall(),
            // ),
            // OutlineButton(
            //   onPressed: () => Navigator.pop(context, _ExitAction.discard),
            //   density: ButtonDensity.dense,
            //   child: Text('Descartar').xSmall(),
            // ),
            PrimaryButton(
              onPressed: () => Navigator.pop(context, _ExitAction.save),
              child: Text('Guardar').xSmall(),
            ),
          ],
        );
      },
    );

    // final action = await m.showDialog<_ExitAction>(
    //   context: context,
    //   builder: (dialogContext) {
    //     return Center(
    //       child: AlertDialog(
    //         title: Text('Cambios sin guardar').small(),
    //         content: Text(
    //           'Tienes cambios pendientes en esta sesión. ¿Qué quieres hacer?',
    //         ).xSmall(),
    //         actions: [
    //           OutlineButton(
    //             onPressed: () =>
    //                 Navigator.pop(dialogContext, _ExitAction.cancel),
    //             child: Text('Cancelar').xSmall(),
    //           ),
    //           OutlineButton(
    //             onPressed: () =>
    //                 Navigator.pop(dialogContext, _ExitAction.discard),
    //             child: Text('Descartar').xSmall(),
    //           ),
    //           PrimaryButton(
    //             onPressed: () => Navigator.pop(dialogContext, _ExitAction.save),
    //             child: Text('Guardar').xSmall(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );

    if (!mounted) return false;

    switch (action) {
      case _ExitAction.save:
        final result = provider.saveSession();
        if (result == 'success') {
          if (!mounted) return false;
          final navigator = Navigator.of(context);
          await context.read<HomeSessionProvider>().loadSessions();
          navigator.pop();
          return false;
        }

        if (result == 'empty') {
          await showDialog<void>(
            context: context,
            builder: (dialogContext) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: AlertDialog(
                    title: Text('Nombre requerido').small(),
                    content: Text(
                      'Escribe un nombre antes de guardar la sesión.',
                    ).xSmall(),
                    actions: [
                      PrimaryButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text('Entendido').xSmall(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          return false;
        }

        if (result == 'emptyData' && mounted) {
          await showDialog<void>(
            context: context,
            builder: (dialogContext) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: AlertDialog(
                    title: Text('Sesión incompleta').small(),
                    content: Text(
                      'Necesitas al menos un ejercicio o una serie para guardar.',
                    ).xSmall(),
                    actions: [
                      PrimaryButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text('Entendido').xSmall(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return false;
      case _ExitAction.discard:
        provider.resetSession();
        return true;
      case _ExitAction.cancel:
      case null:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.session != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<NewSessionProvider>().loadSession(widget.session!);
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NewSessionProvider>().resetSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleExitRequest();
      },
      child: SafeArea(
        child: Scaffold(
          headers: [
            AppBar(
              title: Text(
                widget.session == null ? 'Nueva sesión' : 'Editar sesión',
              ),
              leading: [
                OutlineButton(
                  density: ButtonDensity.icon,
                  onPressed: _handleExitRequest,
                  size: ButtonSize.small,
                  child: Icon(Icons.arrow_back),
                ),
              ],
              trailing: [SaveSessionButton()],
              padding: EdgeInsets.all(10),
            ),
            // Divider(),
          ],
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SessionNameField(),
                          Consumer<NewSessionProvider>(
                            builder: (context, provider, child) {
                              final errorName = provider.errorName;

                              if (errorName) {
                                return Text(
                                  "El nombre de la sesión no puede estar vacío",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    RestTimeSelector(),
                  ],
                ),
                const Gap(20),
                Tabs(
                  index: index,
                  onChanged: (value) {
                    setState(() {
                      index = value;
                    });
                    context.read<NewSessionProvider>().fabType = value;
                  },
                  children: [
                    TabItem(
                      child: Row(
                        children: [
                          Icon(LucideIcons.listOrdered, size: 14),
                          const Gap(5),
                          Text("Ejercicios").xSmall(),
                        ],
                      ),
                    ),
                    TabItem(
                      child: Row(
                        children: [
                          Icon(LucideIcons.folderMinus, size: 14),
                          const Gap(5),
                          Text("Series").xSmall(),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(15),
                Expanded(
                  child: IndexedStack(
                    index: index,
                    children: [ListExercises(), ListSeries()],
                  ),
                ),
                FabButton(onPressed: _openFabSheet),
                const Gap(15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ExitAction { cancel, save, discard }

class FabButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FabButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton.primary(
          onPressed: onPressed,
          icon: Icon(BootstrapIcons.plus),
        ),
      ],
    );
  }
}
