import 'package:delhi_golf_federation/model/registermodel.dart';


// register event
abstract class RegistrationEvent {}

class SubmitRegistrationEvent extends RegistrationEvent {
  final RegistrationRequestModel requestModel;

  SubmitRegistrationEvent(this.requestModel);
}
