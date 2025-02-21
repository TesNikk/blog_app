import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


import '../../../../core/common/entities/user.dart';
import '../../../../core/usecase/usecase.dart';

class CurrentUser implements UseCase<User,NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
   return await authRepository.currentUser();
  }
}
