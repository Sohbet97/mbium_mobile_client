import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/person/bloc/Auth/auth_bloc.dart';

import '../../../generated/l10n.dart';

class CreateNewUserScreen extends StatefulWidget {
  const CreateNewUserScreen({super.key});

  @override
  State<CreateNewUserScreen> createState() => _CreateNewUserScreenState();
}

class _CreateNewUserScreenState extends State<CreateNewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _birthday;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final locale = Localizations.localeOf(context);
    final safeLocale = locale.languageCode == 'tk'
        ? const Locale('ru')
        : locale;

    final picked = await showDatePicker(
      context: context,
      locale: safeLocale,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      CreateNewUserEvent(
        name: _nameController.text.trim(),
        sureName: _surnameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        password: _passwordController.text,
        birthday: _birthday,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is CreateNewUserError) {
            MyHelpers.showMessage(
              loc.nasazlyk_yuze_cykdy,
              AppColors.errorRed,
              context,
            );
          }

          if (state is CreateNewUserSuccess) {
            Navigator.pushReplacementNamed(
              context,
              '/otpVerify',
              arguments: state.sessionId,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _Header(title: loc.register),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Field(
                          controller: _nameController,
                          label: loc.ady,
                          icon: Icons.person_outline,
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        _Field(
                          controller: _surnameController,
                          label: loc.familiasy,
                          icon: Icons.badge_outlined,
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        _Field(
                          controller: _phoneController,
                          label: loc.telefon_belgi,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        _Field(
                          controller: _emailController,
                          label: loc.e_pocta,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return _required(v);
                            if (v.length < 8) return '≥ 8 harp bolmaly';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: loc.parol,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _BirthdayPicker(
                          label: loc.doglan_guni,
                          birthday: _birthday,
                          onTap: _pickBirthday,
                        ),
                        const SizedBox(height: 28),
                        if (state is CreateNewUserProgress)
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              loc.hasap_ac,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'required' : null;
}

class _Header extends StatelessWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff187443), Color(0xff5FA67E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _BirthdayPicker extends StatelessWidget {
  const _BirthdayPicker({
    required this.label,
    required this.birthday,
    required this.onTap,
  });

  final String label;
  final DateTime? birthday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted = birthday != null
        ? DateFormat('dd.MM.yyyy').format(birthday!)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.cake_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          formatted ?? '',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
