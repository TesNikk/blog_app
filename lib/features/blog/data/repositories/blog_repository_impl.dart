import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';

import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/constant.dart';
import '../../domain/repositories/blog_repository.dart';
import '../models/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.connectionChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if(!await connectionChecker.isConnected){
        return Left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: '',
          topics: topics,
          updatedAt: DateTime.now());
      final imageUrl =
          await blogRemoteDataSource.uploadImage(image: image, blog: blogModel);
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return Right(uploadedBlog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
   try{
      if(!await connectionChecker.isConnected){
        final blogs = blogLocalDataSource.loadBlogs();
        return Right(blogs);
      }
     final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return Right(blogs);
   } on ServerException catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog(String blogId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure(Constants.noConnectionErrorMessage));
      }

      await blogRemoteDataSource.deleteBlog(blogId);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

}
