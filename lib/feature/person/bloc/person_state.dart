part of 'person_bloc.dart';

final class PersonState extends Equatable {
  final bool isRegistered;
  final PersonModel? personModel;
  final UserType? userType;
  final String? errorMessage;
  final bool isUpdateProgress;

  const PersonState({
    this.isRegistered = false,
    this.personModel,
    this.userType,
    this.errorMessage,
    this.isUpdateProgress = false,
  });

  PersonState copyWith({
    bool? isRegistered,
    PersonModel? personModel,
    UserType? userType,
    String? errorMessage,
    bool? isUpdateProgress,
  }) {
    return PersonState(
      isRegistered: isRegistered ?? this.isRegistered,
      personModel: personModel ?? this.personModel,
      userType: userType ?? this.userType,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdateProgress: isUpdateProgress ?? this.isUpdateProgress,
    );
  }

  @override
  List<Object?> get props => [
    isRegistered,
    personModel,
    userType,
    errorMessage,
    isUpdateProgress,
  ];
}
