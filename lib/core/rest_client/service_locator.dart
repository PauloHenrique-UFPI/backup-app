import 'package:get_it/get_it.dart';
import 'package:veneza/core/rest_client/dio_client.dart';
import 'package:veneza/models/rest_client.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton<RestClient>(() => DioClient());
}
