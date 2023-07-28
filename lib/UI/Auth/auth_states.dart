abstract class AuthStates {
  
}

class InitialStates extends AuthStates {}

class RegisterLoadingState extends AuthStates{}
class UserCreatedSucessState extends AuthStates{}
class UserCreatedErrorState extends AuthStates{
   String message;
  UserCreatedErrorState({required this.message});
}

class LoginLoadingState extends AuthStates {} 
class LoginSuccessState extends AuthStates {}
class LoginErrorState extends AuthStates {
   String message;
   LoginErrorState({required this.message});
}


class UserImageSelectedSuccessState extends AuthStates{}
class UserImageSelectedErrorState extends AuthStates{}




class FailedToSaveUserDataOnFireStoreState extends AuthStates{}
class SaveUserDataOnFireStoreSuccessState extends AuthStates{}
