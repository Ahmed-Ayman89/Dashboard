part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingsActionLoading extends SettingsState {}

class SettingsActionSuccess extends SettingsState {
  final String message;

  const SettingsActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
