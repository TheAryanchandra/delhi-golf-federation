import 'dart:io';

import 'package:delhi_golf_federation/model/updatedprofile_model.dart';


abstract class AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final UpdateProfileModel model;
  final File? imageFile;

  UpdateProfileEvent({required this.model, this.imageFile});
}
