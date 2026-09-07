import '../entities/starting_baseline.dart';
abstract interface class BaselineRepository { Future<StartingBaseline> getForTrainer(String traineeId); Future<Uri> getPhotoReadUri(String traineeId,String photoId); }
