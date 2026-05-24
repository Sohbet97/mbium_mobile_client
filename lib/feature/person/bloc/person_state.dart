part of 'person_bloc.dart';

final class PersonState extends Equatable {
  final bool isRegistered;
  final PersonModel? personModel;
  final UserType? userType;
  final String? errorMessage;
  final bool isUpdateProgress;
  final bool isGostUser;

  const PersonState({
    this.isRegistered = false,
    this.personModel,
    this.userType,
    this.errorMessage,
    this.isUpdateProgress = false,
    this.isGostUser = false,
  });

  PersonState copyWith({
    bool? isRegistered,
    PersonModel? personModel,
    UserType? userType,
    String? errorMessage,
    bool? isUpdateProgress,
    bool? isGostUser,
  }) {
    return PersonState(
      isRegistered: isRegistered ?? this.isRegistered,
      personModel: personModel ?? this.personModel,
      userType: userType ?? this.userType,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdateProgress: isUpdateProgress ?? this.isUpdateProgress,
      isGostUser: isGostUser ?? this.isGostUser,
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
  ];
}
