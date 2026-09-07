import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../network/api_client.dart';
import 'realtime_client.dart';
import 'realtime_event.dart';

class SseClient implements RealtimeClient {
  SseClient(this._apiClient);

  final ApiClient _apiClient;
  CancelToken? _cancelToken;

  @override
  Stream<RealtimeEvent> connect(String path) async* {
    _cancelToken = CancelToken();
    final response = await _apiClient.raw.get<ResponseBody>(
      path,
      options: Options(responseType: ResponseType.stream, headers: const {'Accept': 'text/event-stream'}),
      cancelToken: _cancelToken,
    );

    final body = response.data;
    if (body == null) return;

    final lines = body.stream.transform(utf8.decoder).transform(const LineSplitter());
    String? event;
    final data = StringBuffer();

    await for (final line in lines) {
      if (line.isEmpty) {
        if (event != null && data.isNotEmpty) {
          yield RealtimeEvent(event: event!, data: data.toString());
        }
        event = null;
        data.clear();
        continue;
      }

      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        if (data.isNotEmpty) data.write('\n');
        data.write(line.substring(5).trim());
      }
    }
  }

  @override
  Future<void> close() async {
    _cancelToken?.cancel('Realtime client closed.');
    _cancelToken = null;
  }
}
