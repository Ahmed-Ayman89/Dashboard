abstract class SetPasswordState {}

class SetPasswordInitial extends SetPasswordState {}

class SetPasswordLoading extends SetPasswordState {}

class SetPasswordSuccess extends SetPasswordState {
  final String message;
  SetPasswordSuccess(this.message);
}

class SetPasswordFailure extends SetPasswordState {
  final String message;
  SetPasswordFailure(this.message);
}
