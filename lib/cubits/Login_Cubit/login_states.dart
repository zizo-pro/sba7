abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class RegisterDropDownChange extends LoginStates {}

class LoginSuccessState extends LoginStates{}
class LoginErrorState extends LoginStates{}

class CreateUserLoadingState extends LoginStates{}
class CreateUserErrorState extends LoginStates{}
class CreateUserSuccessState extends LoginStates{}

class UserRegisterLoadingState extends LoginStates{}
class UserRegisterSuccessState extends LoginStates{}
class UserRegisterErrorState extends LoginStates{}

class GetUserDataSuccessState extends LoginStates{}