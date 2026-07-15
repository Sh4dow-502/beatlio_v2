import 'package:beatlio_v2/models/user.dart';
import 'package:beatlio_v2/provider/user_provider.dart';
import 'package:beatlio_v2/ui/components/custom_text_field.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:flutter/material.dart' show OutlineInputBorder;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final User user = User(name: name);
      context.read<UserProvider>().saveUser(user);
    }
  }

  void onChanged(String value) {
    setState(() {
      _isValid = value.trim().length >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(50),
              Row(
                spacing: 5,
                children: [
                  Text("•").x2Large(
                    color: CustomColors.lightPurple.withValues(alpha: .8),
                  ),
                  Text("INICIO").small().light().muted(),
                ],
              ),
              const Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("¿Cuál es").x4Large().medium(),
                  Text("tu nombre?").x4Large().bold(),
                ],
              ),
              const Gap(10),
              Text("Asi sabemos cómo llamarte").muted().small(),
              const Gap(60),
              CustomTextField(
                // labelText: "Tu nombre",
                hintText: "Tu nombre",
                controller: _nameController,
                onChanged: onChanged,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: .2),
                    width: 1,
                  ),
                ),
              ),
              const Gap(16),
              const Spacer(),
              GestureDetector(
                onTap: _isValid ? _submit : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: _isValid
                        ? colors.primary
                        : colors.secondary.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text("Continuar")
                          .medium(
                            color: _isValid
                                ? Colors.white
                                : Colors.white.withValues(alpha: .5),
                          )
                          .small(),
                    ],
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
