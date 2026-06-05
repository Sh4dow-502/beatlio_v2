import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/ui/components/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SessionNameField extends StatefulWidget {
  const SessionNameField({super.key});

  @override
  State<SessionNameField> createState() => _SessionNameFieldState();
}

class _SessionNameFieldState extends State<SessionNameField> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = context.read<NewSessionProvider>().sessionName;
  }

  @override
  dispose() {
    nameController.dispose();
    super.dispose();
  }

  void onChangeName(String value) {
    context.read<NewSessionProvider>().sessionName = value;
    context.read<NewSessionProvider>().validateSessionName();
  }

  @override
  Widget build(BuildContext context) {
    final sessionName = context.watch<NewSessionProvider>().sessionName;
    if (nameController.text != sessionName) {
      nameController.value = nameController.value.copyWith(
        text: sessionName,
        selection: TextSelection.collapsed(offset: sessionName.length),
        composing: TextRange.empty,
      );
    }

    return CustomTextField(
      controller: nameController,
      labelText: "Nombre de la sesión",
      maxLength: 35,
      maxLines: 1,
      onChanged: onChangeName,
    );
  }
}
