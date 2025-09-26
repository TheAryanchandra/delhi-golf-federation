import 'package:delhi_golf_federation/bloc/auth/auth_bloc.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/bottomnavigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _homeClubController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _handicapController = TextEditingController();
  final TextEditingController _ghinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedGender;
  int? _calculatedAge;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isButtonDisabled = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Calculate age
  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _homeClubController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _handicapController.dispose();
    _ghinController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationLoading) {
          setState(() {
            _isLoading = true;
            _isButtonDisabled = true;
            _errorMessage = null;
          });
        } else if (state is RegistrationSuccess) {
          setState(() {
            _isLoading = false;
            _isButtonDisabled = !(state.response.status ?? false);
            _errorMessage = state.response.message;
          });

          if (state.response.status == true) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomBottomNav(),
              ),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message ?? 'Registration failed'),
              ),
            );
          }
        } else if (state is RegistrationFailure) {
          setState(() {
            _isLoading = false;
            _isButtonDisabled = false;
            _errorMessage = state.error;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/background.png", fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.3)),

            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 120),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 60),

                                const Center(
                                  child: Text(
                                    "REGISTER",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                if (_errorMessage != null && _isButtonDisabled)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                // Full Name
                                _buildLabel("Full Name"),
                                _buildTextField(
                                  controller: _nameController,
                                  hint: "Enter your full name",
                                  icon: Icons.person,
                                  validator: (value) => value == null || value.trim().isEmpty
                                      ? "Full name is required"
                                      : null,
                                ),

                                // Home Club
                                _buildLabel("Home Club"),
                                _buildTextField(
                                  controller: _homeClubController,
                                  hint: "Enter your home club",
                                  icon: Icons.sports_golf,
                                  validator: (value) => value == null || value.trim().isEmpty
                                      ? "Home club is required"
                                      : null,
                                ),

                                // Email
                                _buildLabel("Email"),
                                _buildTextField(
                                  controller: _emailController,
                                  hint: "Enter your email",
                                  icon: Icons.email_outlined,
                                  keyboard: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Email is required";
                                    }
                                    final emailRegex = RegExp(
                                        r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                    if (!emailRegex.hasMatch(value.trim())) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                ),

                                // Phone
                                _buildLabel("Phone Number"),
                                _buildTextField(
                                  controller: _phoneController,
                                  hint: "Enter your phone number",
                                  icon: Icons.phone,
                                  keyboard: TextInputType.phone,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  
                                ),

                                // Gender
                                _buildLabel("Gender"),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    hintText: "Select your gender",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  value: _selectedGender,
                                  items: const [
                                    DropdownMenuItem(value: "Male", child: Text("Male")),
                                    DropdownMenuItem(value: "Female", child: Text("Female")),
                                    DropdownMenuItem(value: "Other", child: Text("Other")),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedGender = value);
                                  },
                                  validator: (value) =>
                                      value == null ? "Please select your gender" : null,
                                ),

                                // DOB
                                _buildLabel("Date of Birth"),
                                GestureDetector(
                                  onTap: () async {
                                    DateTime today = DateTime.now();
                                    DateTime tenYearsAgo = DateTime(
                                      today.year - 10,
                                      today.month,
                                      today.day,
                                    );

                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: tenYearsAgo,
                                      firstDate: DateTime(1900),
                                      lastDate: tenYearsAgo,
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          "${pickedDate.day.toString().padLeft(2, '0')}/"
                                          "${pickedDate.month.toString().padLeft(2, '0')}/"
                                          "${pickedDate.year}";
                                      setState(() {
                                        _dobController.text = formattedDate;
                                        _calculatedAge = _calculateAge(pickedDate);
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: _buildTextField(
                                      controller: _dobController,
                                      hint: "DD/MM/YYYY",
                                      icon: Icons.date_range,
                                    ),
                                  ),
                                ),

                                // Handicap
                                _buildLabel("USGA Handicap (Index)"),
                                _buildTextField(
                                  controller: _handicapController,
                                  hint: "Enter your handicap index",
                                  icon: Icons.score,
                                  keyboard: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r"^[0-9]*\.?[0-9]*$"),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Handicap is required";
                                    }
                                    final numericRegex =
                                        RegExp(r"^[0-9]+(\.[0-9]+)?$");
                                    if (!numericRegex.hasMatch(value.trim())) {
                                      return "Enter a valid number";
                                    }
                                    return null;
                                  },
                                ),

                                // GHIN
                                _buildLabel("GHIN No"),
                                _buildTextField(
                                  controller: _ghinController,
                                  hint: "Enter your GHIN number",
                                  icon: Icons.confirmation_number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) => value == null || value.trim().isEmpty
                                      ? "GHIN number is required"
                                      : null,
                                ),

                                // Password
                                _buildLabel("Password"),
                                _buildTextField(
                                  controller: _passwordController,
                                  hint: "Enter your password",
                                  icon: Icons.lock_outline,
                                  obscure: true,
                                 
                                ),

                                const SizedBox(height: 20),

                                // Register Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0B592A),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_isButtonDisabled) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(_errorMessage ??
                                                  'Registration failed'),
                                            ),
                                          );
                                          return;
                                        }

                                        String dob = _dobController.text;
                                        int? age = _calculatedAge;

                                        if (dob.isEmpty || age == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Please select your Date of Birth"),
                                            ),
                                          );
                                          return;
                                        }

                                        if (age < 10) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("You must be at least 10 years old"),
                                            ),
                                          );
                                          return;
                                        }


                                      print("Name: ${_nameController.text}");
                                      print("Phone Number: ${_phoneController.text}");  
                                      print("Date of Birth: $dob");
                                      print("Age: $age");
                                      print("Gender: $_selectedGender");
                                      print("Handicap Index: ${double.parse(_handicapController.text)}");
                                      print("GHIN No: ${_ghinController.text}");
                                      print("Source: APP");
                                      print("Home Club: ${_homeClubController.text}");
                                      print("Email: ${_emailController.text}");
                                    
                                      // Perform registration logic here
                                        final request = RegistrationRequestModel(
                                          id: 0,
                                          name: _nameController.text,
                                          phonumber: _phoneController.text,
                                          email: _emailController.text,
                                          gender: _selectedGender ?? "",
                                          password: _passwordController.text,
                                          dob: dob,
                                          age: age,
                                          homeClub: _homeClubController.text,
                                          usgaHandicapIndex: double.tryParse(
                                                  _handicapController.text) ??
                                              0.0,
                                          ghinNo: _ghinController.text,
                                          cmpCode: null,
                                          roleId: null,
                                          refNo: null,
                                          source: "APP",
                                        );

                                        context
                                            .read<RegistrationBloc>()
                                            .add(SubmitRegistrationEvent(request));
                                      }
                                    },
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Already have an account? Login"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: -50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage(
                                "assets/images/logo.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    TextEditingController? controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }
}
