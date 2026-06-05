import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_serie/bpm_controller.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_serie/duration_controller.dart';
import 'package:beatlio_v2/ui/components/custom_text_field.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

class FormNewSerie extends StatefulWidget {
  final bool isEditing;
  final Serie? serie;
  final int? serieIndex;
  const FormNewSerie({
    super.key,
    this.isEditing = false,
    this.serie,
    this.serieIndex,
  });

  @override
  State<FormNewSerie> createState() => _FormNewSerieState();
}

class _FormNewSerieState extends State<FormNewSerie> {
  final TextEditingController nameController = TextEditingController();
  bool durationEnabled = true;
  bool bpmEnabled = true;
  int durationValue = 60;
  int bpmValue = 120;

  String uid = Uuid().v4();
  bool nameError = false;

  bool get hasGlobalConfig => bpmEnabled || durationEnabled;

  Widget buildGlobalConfigSummary() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            color: colors.mutedForeground,
            fontSize: 12,
            height: 1.2,
          ),
          children: [
            const TextSpan(text: 'Configuración global: '),
            if (durationEnabled)
              TextSpan(
                text: formatDuration(durationValue),
                style: TextStyle(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (durationEnabled && bpmEnabled) const TextSpan(text: ' · '),
            if (bpmEnabled)
              TextSpan(
                text: '$bpmValue BPM',
                style: TextStyle(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    durationEnabled = widget.serie?.durationGlobal ?? true;
    bpmEnabled = widget.serie?.bpmGlobal ?? true;
    durationValue = widget.serie?.durationValueGlobal ?? 60;
    bpmValue = widget.serie?.bpmValueGlobal ?? 120;

    nameController.text = widget.serie?.name ?? "";

    uid = widget.serie?.uid ?? Uuid().v4();

    super.initState();
  }

  void updateDurationEnabled(bool value) {
    setState(() {
      durationEnabled = value;
    });
  }

  void updateBPMEnabled(bool value) {
    setState(() {
      bpmEnabled = value;
    });
  }

  void updateDurationValue(int value) {
    setState(() {
      durationValue = value;
    });
  }

  void updateBPMValue(int value) {
    setState(() {
      bpmValue = value;
    });
  }

  bool validateName(String name) {
    setState(() {
      nameError = name.trim().isEmpty;
    });
    return !nameError;
  }

  void saveSerie() {
    final validatedName = nameController.text.trim();

    if (!validateName(validatedName)) {
      return;
    }
    Serie serie = Serie(
      name: nameController.text,
      uid: uid,
      bpmGlobal: bpmEnabled,
      durationGlobal: durationEnabled,
      bpmValueGlobal: bpmEnabled ? bpmValue : 120,
      durationValueGlobal: durationEnabled ? durationValue : 60,
      exercises: widget.serie?.exercises ?? [],
    );

    if (widget.isEditing) {
      context.read<NewSessionProvider>().editSerieByUid(
        widget.serie!.uid,
        serie,
      );
    } else {
      context.read<NewSessionProvider>().addSerie(serie);
    }
    // closeSheet(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(child: Text("Nueva serie")),
            const Gap(15),
            // Text("Nombre de la serie:").xSmall(),
            // const Gap(8),
            CustomTextField(
              autofocus: widget.isEditing ? false : true,
              maxLength: 25,
              controller: nameController,
              labelText: ("Nombre de la serie"),
            ),
            // TextField(
            //   autofocus: true,
            //   placeholder: Text("Ej: Rudimentos basicos").xSmall(),
            //   maxLength: 25,
            //   maxLines: 1,
            //   controller: nameController,
            //   features: [InputFeature.clear()],
            // ),
            // const Gap(5),
            const Gap(2),
            if (nameError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 5),
                child: Text(
                  "El nombre no puede estar vacio",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            const Gap(30),
            if (hasGlobalConfig) buildGlobalConfigSummary(),
            if (hasGlobalConfig) const Gap(8),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                BPMController(
                  initBPM: bpmValue,
                  bpmEnabled: bpmEnabled,
                  onBPMChanged: updateBPMValue,
                  onBPMEnabledChanged: updateBPMEnabled,
                ),
                DurationController(
                  initDuration: durationValue,
                  durationEnabled: durationEnabled,
                  onDurationChanged: updateDurationValue,
                  onDurationEnabledChanged: updateDurationEnabled,
                ),
              ],
            ),
            const Gap(80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PrimaryButton(
                    alignment: Alignment.center,
                    density: ButtonDensity.comfortable,
                    onPressed: () {
                      saveSerie();
                    },
                    child: Text("Guardar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
