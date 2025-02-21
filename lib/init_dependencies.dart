import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/current_user.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  //Data Source
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  //Repository
  serviceLocator.registerFactory<AuthRepository>(()=>
    AuthRepositoryImpl(
      serviceLocator(),
    ),
  );
  //Use Cases
  serviceLocator.registerFactory(()=>
    UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(()=>
      UserLogin(
        serviceLocator(),
      ),
  );

  serviceLocator.registerFactory(()=>
    CurrentUser(
      serviceLocator(),
    ),
  );
  //Bloc
  serviceLocator.registerLazySingleton(()=>
    AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}
