import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecases/create_client.dart';
import '../../domain/usecases/pause_client.dart';
import '../../domain/usecases/resume_client.dart';
import '../providers/clients_providers.dart';

class ClientMutationController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Client?> create(CreateClientInput input) async {
    state = const AsyncLoading();
    Client? result;
    state = await AsyncValue.guard(() async {
      result = await CreateClient(ref.read(clientsRepositoryProvider))(input);
      ref.invalidate(clientsProvider);
    });
    return result;
  }

  Future<void> pause(String id, {DateTime? pauseUntil}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await PauseClient(ref.read(clientsRepositoryProvider))(id, pauseUntil: pauseUntil);
      ref.invalidate(clientProvider(id));
      ref.invalidate(clientsProvider);
    });
  }

  Future<void> resume(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ResumeClient(ref.read(clientsRepositoryProvider))(id);
      ref.invalidate(clientProvider(id));
      ref.invalidate(clientsProvider);
    });
  }
}

final clientMutationControllerProvider = AutoDisposeAsyncNotifierProvider<ClientMutationController, void>(ClientMutationController.new);
