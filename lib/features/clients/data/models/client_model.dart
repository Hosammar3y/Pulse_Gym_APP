import '../../domain/entities/client.dart';

class ClientModel {
  const ClientModel(this.json);
  final Map<String, dynamic> json;

  Client toEntity() => Client(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        phone: json['phone'] as String?,
        goal: json['goal'] as String? ?? '',
        trainingLevel: _trainingLevel(json['trainingLevel'] as String?),
        heightCm: (json['heightCm'] as num?)?.toDouble(),
        status: _status(json['status'] as String?),
        checkInFrequencyDays: json['checkInFrequencyDays'] as int?,
        pauseUntil: _date(json['pauseUntil']),
        subscriptionStartDate: DateTime.parse(json['subscriptionStartDate'] as String),
        subscriptionEndDate: DateTime.parse(json['subscriptionEndDate'] as String),
        subscriptionStatus: json['subscriptionStatus'] as String? ?? 'UNKNOWN',
        baselineRequirement: (json['baselineRequirement'] as String?) == 'REQUIRED'
            ? BaselineRequirement.required
            : BaselineRequirement.optional,
        baselineStatus: _baselineStatus(json['baselineStatus'] as String?),
      );

  static ClientStatus _status(String? value) => switch (value) {
        'INVITED' => ClientStatus.invited,
        'PAUSED' => ClientStatus.paused,
        'EXPIRED' => ClientStatus.expired,
        'ARCHIVED' => ClientStatus.archived,
        _ => ClientStatus.active,
      };

  static TrainingLevel? _trainingLevel(String? value) => switch (value) {
        'BEGINNER' => TrainingLevel.beginner,
        'INTERMEDIATE' => TrainingLevel.intermediate,
        'ADVANCED' => TrainingLevel.advanced,
        _ => null,
      };

  static BaselineStatus _baselineStatus(String? value) => switch (value) {
        'IN_PROGRESS' => BaselineStatus.inProgress,
        'COMPLETED' => BaselineStatus.completed,
        _ => BaselineStatus.notStarted,
      };

  static DateTime? _date(Object? value) => value is String && value.isNotEmpty ? DateTime.tryParse(value) : null;
}

Map<String, dynamic> createClientJson(CreateClientInput input) => <String, dynamic>{
      'firstName': input.firstName,
      'lastName': input.lastName,
      'email': input.email,
      if (input.phone?.isNotEmpty == true) 'phone': input.phone,
      'goal': input.goal,
      if (input.trainingLevel != null) 'trainingLevel': input.trainingLevel!.name.toUpperCase(),
      if (input.heightCm != null) 'heightCm': input.heightCm,
      'subscriptionStartDate': _dateOnly(input.subscriptionStartDate),
      if (input.subscriptionEndDate != null) 'subscriptionEndDate': _dateOnly(input.subscriptionEndDate!),
      if (input.checkInFrequencyDays != null) 'checkInFrequencyDays': input.checkInFrequencyDays,
      'baselineRequirement': input.baselineRequirement == BaselineRequirement.required ? 'REQUIRED' : 'OPTIONAL',
    };

String _dateOnly(DateTime value) => value.toIso8601String().split('T').first;
