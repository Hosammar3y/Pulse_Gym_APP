import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/starting_baseline.dart';
import '../models/starting_baseline_model.dart';

class BaselineRemoteDataSource {
  BaselineRemoteDataSource(this._api, {Dio? uploadClient}) : _uploadClient = uploadClient ?? Dio();

  final ApiClient _api;
  final Dio _uploadClient;

  String _base(String traineeId) => '/trainer/trainees/$traineeId/starting-baseline';

  Future<StartingBaselineModel> trainerView(String traineeId) async => StartingBaselineModel(
        Map<String, dynamic>.from(await _api.get<Map<String, dynamic>>(_base(traineeId))),
      );

  Future<BaselineUploadIntent> requestUploadIntent(
    String traineeId,
    BaselineAngle angle,
    String contentType,
  ) async {
    final data = await _api.post<Map<String, dynamic>>(
      '${_base(traineeId)}/photos/upload-intents',
      data: <String, dynamic>{'angle': angle.apiValue, 'contentType': contentType},
    );
    return parseBaselineUploadIntent(Map<String, dynamic>.from(data));
  }

  Future<void> uploadBytes(
    BaselineUploadIntent intent,
    Uint8List bytes,
    String contentType,
  ) async {
    final headers = Map<String, String>.from(intent.requiredHeaders);
    final hasContentType = headers.keys.any((key) => key.toLowerCase() == 'content-type');
    if (!hasContentType) headers['Content-Type'] = contentType;

    await _uploadClient.putUri<void>(
      intent.url,
      data: bytes,
      options: Options(
        headers: headers,
        responseType: ResponseType.plain,
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );
  }

  Future<Map<String, dynamic>> confirm(String traineeId, String photoId) => _api.post<Map<String, dynamic>>(
        '${_base(traineeId)}/photos/$photoId/confirm',
      );

  Future<void> remove(String traineeId, String photoId) async {
    await _api.delete<dynamic>('${_base(traineeId)}/photos/$photoId');
  }

  Future<StartingBaselineModel> complete(String traineeId, double startingWeightKg) async => StartingBaselineModel(
        Map<String, dynamic>.from(
          await _api.post<Map<String, dynamic>>(
            '${_base(traineeId)}/complete',
            data: <String, dynamic>{'startingWeightKg': startingWeightKg},
          ),
        ),
      );

  Future<Map<String, dynamic>> photoReadAccess(String traineeId, String photoId) => _api.get<Map<String, dynamic>>(
        '${_base(traineeId)}/photos/$photoId/read-access',
      );
}
