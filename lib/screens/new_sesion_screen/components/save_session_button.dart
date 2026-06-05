import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/form_new_excercise.dart';
import 'package:beatlio_v2/provider/home_session_provider.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SaveSessionButton extends StatelessWidget {
  const SaveSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () async {
        final navigator = Navigator.of(context);
        final homeSessionProvider = context.read<HomeSessionProvider>();
        final result = context.read<NewSessionProvider>().saveSession();

        if (result == "success") {
          await homeSessionProvider.loadSessions();
          navigator.pop();
          return;
        }

        if (result == "emptyData") {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text("Sesión incompleta").small(),
                content: Text(
                  "Necesitas al menos un ejercicio para comenzar a practicar.",
                ).xSmall(),
                actions: [
                  OutlineButton(
                    child: Text("Cancelar").xSmall(),
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                  PrimaryButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);

                      openMaterialSheet(
                        context: context,
                        builder: (sheetContext) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(
                                    sheetContext,
                                  ).viewInsets.bottom +
                                  5,
                            ),
                            child: FormNewExcercise(),
                          );
                        },
                      );
                    },
                    child: Text("Agregar ejercicio").xSmall(),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Text("Guardar"),
    );
  }
}
