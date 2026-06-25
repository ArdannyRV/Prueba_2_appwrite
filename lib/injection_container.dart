import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:appwrite/appwrite.dart';
import 'core/constants/app_constants.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize Appwrite
  final client = Client()
      .setEndpoint(AppConstants.appwriteEndpoint)
      .setProject(AppConstants.appwriteProjectId);

  // Register external dependencies
  getIt.registerLazySingleton<Client>(() => client);
  getIt.registerLazySingleton<Account>(() => Account(client));
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Initialize injectable
  getIt.init();
}
