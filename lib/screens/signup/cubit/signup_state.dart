part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final SignupStatus status;
  final Failure failure;

  const SignupState({
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid => username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  factory SignupState.initial() {
    return SignupState(
      username: '',
        email: '',
        password: '',
        status: SignupStatus.initial,
        failure: Failure());
  }

  @override
  List<Object> get props => [username,password,status,email,failure];

  @override
  bool get stringify => true;

  SignupState copyWith({
    String username,
    String email,
    String password,
    SignupStatus status,
    Failure failure,
  }) {
    return SignupState(
       username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        failure: failure ?? this.failure);
  }
}