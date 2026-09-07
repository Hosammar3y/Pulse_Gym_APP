enum ClientStatus { invited, active, paused, expired, archived }
enum TrainingLevel { beginner, intermediate, advanced }
enum BaselineRequirement { required, optional }
enum BaselineStatus { notStarted, inProgress, completed }

class Client {
  const Client({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.goal,
    required this.status,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.subscriptionStatus,
    this.phone,
    this.trainingLevel,
    this.heightCm,
    this.checkInFrequencyDays,
    this.pauseUntil,
    this.baselineRequirement = BaselineRequirement.optional,
    this.baselineStatus = BaselineStatus.notStarted,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String goal;
  final TrainingLevel? trainingLevel;
  final double? heightCm;
  final ClientStatus status;
  final int? checkInFrequencyDays;
  final DateTime? pauseUntil;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;
  final String subscriptionStatus;
  final BaselineRequirement baselineRequirement;
  final BaselineStatus baselineStatus;

  String get displayName => '$firstName $lastName'.trim();
}

class CreateClientInput {
  const CreateClientInput({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.goal,
    required this.subscriptionStartDate,
    this.phone,
    this.trainingLevel,
    this.heightCm,
    this.subscriptionEndDate,
    this.checkInFrequencyDays,
    this.baselineRequirement = BaselineRequirement.optional,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String goal;
  final TrainingLevel? trainingLevel;
  final double? heightCm;
  final DateTime subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final int? checkInFrequencyDays;
  final BaselineRequirement baselineRequirement;
}
