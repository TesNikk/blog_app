part of 'init_dependencies.dart';
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  //Data Source
  serviceLocator.registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  //Repository
  serviceLocator.registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );
  //Use Cases
  serviceLocator.registerFactory(
        () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => CurrentUser(
      serviceLocator(),
    ),
  );
  //Bloc
  serviceLocator.registerLazySingleton(
        () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
          () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
          () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
  // Repository
    ..registerFactory<BlogRepository>(
          () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
  // Usecases
    ..registerFactory(
          () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
          () => GetAllBlogs(
        serviceLocator(),
      ),
    )
  // Bloc
    ..registerLazySingleton(
          () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
