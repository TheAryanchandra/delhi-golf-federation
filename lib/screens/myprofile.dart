import 'dart:io';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_event.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_state.dart';
import 'package:delhi_golf_federation/bloc/updateimage/bloc/updateimage_bloc.dart';
import 'package:delhi_golf_federation/bloc/updateimage/bloc/updateimage_event.dart';
import 'package:delhi_golf_federation/bloc/updateimage/bloc/updateimage_state.dart';
import 'package:delhi_golf_federation/model/updatedprofile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../components/color_constants.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    // ✅ Fetch user data every time screen opens
    context.read<UserDataBloc>().add(FetchUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F1),
      body: BlocBuilder<UserDataBloc, UserDataState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDataError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is UserDataLoaded) {
            final user = state.userData;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ✅ Header
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/welcome.png",
                          height: screenHeight * 0.20,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: screenHeight * 0.20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorConstants.buttonColor.withOpacity(0.9),
                                Colors.black.withOpacity(0.4),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        const Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ Profile Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor:
                                ColorConstants.buttonColor.withOpacity(0.2),
                            backgroundImage: user.profileImg != null &&
                                    user.profileImg!.isNotEmpty
                                ? NetworkImage(user.profileImg!)
                                : null,
                            child: (user.profileImg == null ||
                                    user.profileImg!.isEmpty)
                                ? const Icon(Icons.person,
                                    size: 42, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name.isNotEmpty
                                      ? user.name.trim()
                                      : "Unnamed User",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  user.homeClub.isNotEmpty
                                      ? user.homeClub
                                      : "No Club",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    _buildChip(Icons.person, user.gender),
                                    _buildChip(Icons.cake, user.dob),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  ColorConstants.buttonColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit,
                                  color: ColorConstants.buttonColor),
                              onPressed: () {
                                _showEditProfileDialog(context, user);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ Handicap Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  ColorConstants.buttonColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.golf_course,
                                color: ColorConstants.buttonColor, size: 30),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "USGA Handicap Index\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Your official golf handicap",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            user.usgaHandicapIndex.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ About Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ColorConstants.buttonColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfo("Name", user.name),
                          _buildInfo("Email", user.email),
                          _buildInfo("Phone", user.phoneNumber),
                          _buildInfo("GHIN No", user.ghinNo),
                          _buildInfo("Age", user.age),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  // ✅ Edit Profile Dialog
  Future<void> _showEditProfileDialog(BuildContext context, dynamic user) async {
  final picker = ImagePicker();
  File? selectedImage;

  final nameController = TextEditingController(text: user.name);
  final emailController = TextEditingController(text: user.email);
  final phoneController = TextEditingController(text: user.phoneNumber);
  final genderController = TextEditingController(text: user.gender);
  final dobController = TextEditingController(text: user.dob);

  await showDialog(
    context: context,
    builder: (context) {
      return BlocConsumer<UpdateProfileBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            Navigator.pop(context);
            context.read<UserDataBloc>().add(FetchUserDataEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully")),
            );
          } else if (state is UpdateProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: const Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final XFile? picked =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        selectedImage = File(picked.path);
                        // since this is inside a dialog, use StatefulBuilder for local setState
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (user.profileImg != null &&
                                  user.profileImg!.isNotEmpty)
                              ? NetworkImage(user.profileImg!)
                              : null,
                      child: selectedImage == null &&
                              (user.profileImg == null ||
                                  user.profileImg!.isEmpty)
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField("Name", nameController, readOnly: true),
                  _buildTextField("Email", emailController, readOnly: true),
                  _buildTextField("Phone", phoneController, readOnly: false),
                  _buildTextField("Gender", genderController, readOnly: true),
                  _buildTextField("DOB", dobController, readOnly: true),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.buttonColor,
                  foregroundColor: Colors.white, // white text
                ),
                onPressed: state is UpdateProfileLoading
                    ? null
                    : () {
                        final model = UpdateProfileModel(
                          id: user.id,
                          name: nameController.text,
                          phonumber: phoneController.text,
                          email: emailController.text,
                          gender: genderController.text,
                          dob: dobController.text,
                          cmpCode: user.cmpCode,
                          refNo: user.refNo,
                          activateStatus: "Activate",
                          homeClub: user.homeClub,
                          usgaHandicapIndex: user.usgaHandicapIndex,
                        );

                        context.read<UpdateProfileBloc>().add(
                              UpdateProfileEvent(
                                model: model,
                                imageFile: selectedImage,
                              ),
                            );
                      },
                child: state is UpdateProfileLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}

/// helper for consistent textfield style
Widget _buildTextField(String label, TextEditingController controller,
    {bool readOnly = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}


  // Widget _buildTextField(String label, TextEditingController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: TextField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border:
  //             OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //       ),
  //     ),
  //   );
  // }

  static Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorConstants.buttonColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorConstants.buttonColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ColorConstants.buttonColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfo(String label, dynamic value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : "N/A",
              style: TextStyle(
                fontSize: 13,
                color: color ?? Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
