import 'realtime_event.dart';

abstract interface class RealtimeClient {
  Stream<RealtimeEvent> connect(String path);
  Future<void> close();
}
