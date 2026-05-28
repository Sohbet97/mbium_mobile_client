part of 'person_bloc.dart';

final class PersonState extends Equatable {
  final bool isRegistered;
  final PersonModel? personModel;
  final UserType? userType;
  final String? errorMessage;
  final bool isUpdateProgress;
  final bool isGostUser;
  final bool isLoading;

  const PersonState({
    this.isRegistered = false,
    this.personModel,
    this.userType,
    this.errorMessage,
    this.isUpdateProgress = false,
    this.isGostUser = false,
    this.isLoading = false,
  });

  PersonState copyWith({
    bool? isRegistered,
    PersonModel? personModel,
    UserType? userType,
    String? errorMessage,
    bool? isUpdateProgress,
    bool? isGostUser,
    bool? isLoading,
    bool clearError = false,
  }) {
    return PersonState(
      isRegistered: isRegistered ?? this.isRegistered,
      personModel: personModel ?? this.personModel,
      userType: userType ?? this.userType,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isUpdateProgress: isUpdateProgress ?? this.isUpdateProgress,
      isGostUser: isGostUser ?? this.isGostUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    isRegistered,
    personModel,
    userType,
    errorMessage,
    isUpdateProgress,
    isGostUser,
    isLoading,
  ];
}
