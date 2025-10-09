import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/color_constants.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_state.dart';
import 'package:delhi_golf_federation/model/getdatamodel.dart';

class EventRegisterPopup extends StatefulWidget {
  const EventRegisterPopup({super.key});

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

  String? _selectedGender;
  String? _selectedIndustry;

  final List<String> _genderOptions = ["Male", "Female", "Other"];
  final List<String> _industryOptions = ["IT", "Finance", "Education", "Sports", "Other"];

  @override
  void dispose() {
    _nameController.dispose();
    _clubController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _handicapController.dispose();
    _ghinController.dispose();
    _passwordController.dispose();
    super.dispose();
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

    // Validate gender and industry safely
    if (_genderOptions.contains(userData.gender)) {
      _selectedGender = userData.gender;
    } else {
      _selectedGender = null;
    }

    if (_industryOptions.contains(userData.industryRefNo)) {
      _selectedIndustry = userData.industryRefNo;
    } else {
      _selectedIndustry = null;
    }
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
          _fillForm(state.userData);
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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

                    _buildTextField(_nameController, Icons.person, "Enter your full name"),
                    _buildTextField(_clubController, Icons.groups_3_outlined, "Enter your home club"),
                    _buildTextField(
                      _emailController,
                      Icons.email_outlined,
                      "Email",
                      enabled: false,
                    ),
                    _buildTextField(_phoneController, Icons.phone, "Enter your phone number", keyboardType: TextInputType.phone),

                    // Gender Dropdown
                    _buildDropdown(
                      icon: Icons.person_outline,
                      hint: "Select your gender",
                      value: _genderOptions.contains(_selectedGender) ? _selectedGender : null,
                      items: _genderOptions,
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),

                    // Industry Dropdown
                    _buildDropdown(
                      icon: Icons.business_outlined,
                      hint: "Select your industry",
                      value: _industryOptions.contains(_selectedIndustry) ? _selectedIndustry : null,
                      items: _industryOptions,
                      onChanged: (val) => setState(() => _selectedIndustry = val),
                    ),

                    _buildDatePicker(context),
                    _buildTextField(_handicapController, Icons.sports_golf, "Enter your handicap index"),
                    _buildTextField(_ghinController, Icons.confirmation_number_outlined, "Enter your GHIN number"),
                    _buildTextField(_passwordController, Icons.lock_outline, "Enter your password", obscureText: true),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Form submitted successfully!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorConstants.buttonColor),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required field" : null,
      ),
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
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
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
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: ColorConstants.buttonColor),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(_dobController, Icons.calendar_today_outlined, "Date of Birth"),
      ),
    );
  }
}
