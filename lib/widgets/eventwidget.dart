import 'package:delhi_golf_federation/bloc/auth/auth_bloc.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_event.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_state.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_state.dart';

import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/model/eventregistermodel.dart';
import 'package:delhi_golf_federation/model/getdatamodel.dart';
import 'package:delhi_golf_federation/model/industrymodel.dart';
import 'package:delhi_golf_federation/services/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventRegisterPopup extends StatefulWidget {
  final String eventRefNo;
  const EventRegisterPopup({super.key, required this.eventRefNo});

  @override
  State<EventRegisterPopup> createState() => _EventRegisterPopupState();
}

class _EventRegisterPopupState extends State<EventRegisterPopup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _clubController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _handicapController = TextEditingController();
  final TextEditingController _ghinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isProgressVisible = false;
  bool _prefilled = false;

  String? _selectedGender;
  String? _selectedIndustry;

  final List<String> _genderOptions = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    context.read<IndustryBloc>().add(FetchIndustriesEvent());
  }

  void _fillForm(UserDataModel userData) {
    _nameController.text = userData.name;
    _clubController.text = userData.homeClub;
    _emailController.text = userData.email;
    _phoneController.text = userData.phoneNumber;
    _dobController.text = userData.dob;
    _handicapController.text = userData.usgaHandicapIndex.toString();
    _ghinController.text = userData.ghinNo;
    _passwordController.text = userData.password;
    _selectedGender = _genderOptions.contains(userData.gender)
        ? userData.gender
        : null;
    _selectedIndustry = userData.industryRefNo;
  }

  int _calculateAge(String dob) {
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final birthDate = DateTime(year, month, day);
        final today = DateTime.now();
        int age = today.year - birthDate.year;
        if (today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }
        return age;
      }
    } catch (_) {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserDataError) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        } else if (state is UserDataLoaded) {
          if (!_prefilled) {
            _fillForm(state.userData);
            _prefilled = true;
          }
        }

        return BlocListener<EventRegistrationBloc, EventRegistrationState>(
          listener: (context, state) {
            if (state is EventRegistrationLoading) {
              _isProgressVisible = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else {
              if (_isProgressVisible) {
                final nav = Navigator.of(context, rootNavigator: true);
                if (nav.canPop()) {
                  nav.pop();
                }
                _isProgressVisible = false;
              }
            }

            if (state is EventRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ ${state.response.message}")),
              );
              final navigator = Navigator.of(context, rootNavigator: true);
              navigator.pop();
              Future.delayed(const Duration(milliseconds: 500), () {
                navigator.pushNamed(RoutesName.paymentScreen);
              });
            } else if (state is EventRegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ ${state.error}")),
              );
            }
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "REGISTER",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.buttonColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// ✅ Using GlobalTextField everywhere
                      GlobalTextField(
                        controller: _nameController,
                        prefixIcon: Icons.person,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required field" : null,
                      ),
                      GlobalTextField(
                        controller: _clubController,
                        prefixIcon: Icons.groups_3_outlined,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required field" : null,
                      ),
                      GlobalTextField(
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        enabled: false,
                      ),
                      GlobalTextField(
                        controller: _phoneController,
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required field" : null,
                      ),

                      /// ✅ Gender Dropdown
                      _buildDropdown(
                        icon: Icons.person_outline,
                        hint: "Select your gender",
                        value: _selectedGender,
                        items: _genderOptions,
                        onChanged: (val) =>
                            setState(() => _selectedGender = val),
                      ),

                      /// ✅ Industry Dropdown via Bloc
                      BlocBuilder<IndustryBloc, IndustryState>(
                        builder: (context, state) {
                          if (state is IndustryLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is IndustryLoaded) {
                            final industryNames =
                                state.industries.map((e) => e.name).toList();

                            // Map stored refNo to name once industries are loaded
                            if (_selectedIndustry != null &&
                                !industryNames.contains(_selectedIndustry)) {
                              final match = state.industries.firstWhere(
                                (e) => e.refNo.toString() == _selectedIndustry,
                                orElse: () => IndustryModel(id: 0, name: '', refNo: ''),
                              );
                              if (match.name.isNotEmpty) {
                                _selectedIndustry = match.name;
                              } else {
                                _selectedIndustry = null;
                              }
                            }

                            return _buildDropdown(
                              icon: Icons.business_outlined,
                              hint: "Select your industry",
                              value: _selectedIndustry,
                              items: industryNames,
                              onChanged: (val) =>
                                  setState(() => _selectedIndustry = val),
                            );
                          } else if (state is IndustryError) {
                            return Text(
                              "Failed to load industries: ${state.message}",
                              style: const TextStyle(color: Colors.red),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      _buildDatePicker(context),

                      GlobalTextField(
                        controller: _handicapController,
                        prefixIcon: Icons.sports_golf,
                      ),
                      GlobalTextField(
                        controller: _ghinController,
                        prefixIcon: Icons.confirmation_number_outlined,
                      ),
                      // GlobalTextField(
                      //   controller: _passwordController,
                      //   prefixIcon: Icons.lock_outline,
                      //   obscureText: true,
                      //   validator: (v) =>
                      //       v == null || v.isEmpty ? "Required field" : null,
                      // ),

                      const SizedBox(height: 20),

                      BlocBuilder<EventRegistrationBloc,
                          EventRegistrationState>(
                        builder: (context, state) {
                          final isLoading = state is EventRegistrationLoading;
                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      final request = EventRegistrationRequest(
                                        id: 0,
                                        name: _nameController.text.trim(),
                                        phonumber: _phoneController.text.trim(),
                                        email: _emailController.text.trim(),
                                        gender: _selectedGender ?? "",
                                        password:
                                            _passwordController.text.trim(),
                                        dob: _dobController.text.trim(),
                                        age: _calculateAge(
                                            _dobController.text.trim()),
                                        homeClub: _clubController.text.trim(),
                                        usgaHandicapIndex: double.tryParse(
                                              _handicapController.text.trim(),
                                            ) ??
                                            0.0,
                                        ghinNo: _ghinController.text.trim(),
                                        cmpCode: null,
                                        roleId: null,
                                        eventRefNo: widget.eventRefNo,
                                        source: "APP",
                                      );
                                      print(request.toJson());
                                      print('Submitting registration...');
                                      print(request);
                                       print("Sending EventRegistrationRequest: $request");
                                      print("Event Ref No: ${widget.eventRefNo}");
                                      print("Name: ${request.name}");
                                      print("Email: ${request.email}");
                                      print("Phone: ${request.phonumber}");
                                      print("Gender: ${request.gender}");
                                      print("DOB: ${request.dob}");
                                      print("Age: ${request.age}");
                                      print("Home Club: ${request.homeClub}");
                                      print("Handicap: ${request.usgaHandicapIndex}");
                                      print("GHIN: ${request.ghinNo}");
                                      print("Source: ${request.source}");
                                      context
                                          .read<EventRegistrationBloc>()
                                          .add(SubmitEventRegistration(request));
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.buttonColor,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: (value != null && items.contains(value)) ? value : null,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorConstants.buttonColor),
          border: InputBorder.none,
        ),
        hint: Text(hint),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        validator: (val) => val == null ? "Required field" : null,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorConstants.buttonColor,
              ),
            ),
            child: child!,
          ),
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: GlobalTextField(
          controller: _dobController,
          prefixIcon: Icons.calendar_today_outlined,
          validator: (v) =>
              v == null || v.isEmpty ? "Please select your DOB" : null,
        ),
      ),
    );
  }
}
