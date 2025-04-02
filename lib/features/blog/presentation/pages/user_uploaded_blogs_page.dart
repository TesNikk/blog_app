import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../blog/presentation/bloc/blog_bloc.dart';
import '../widgets/blog_list_tile.dart';

class UserUploadedBlogsPage extends StatefulWidget {
  const UserUploadedBlogsPage({super.key});

  static Route route() => MaterialPageRoute(
    builder: (context) => const UserUploadedBlogsPage(),
  );

  @override
  State<UserUploadedBlogsPage> createState() => _UserUploadedBlogsPageState();
}

class _UserUploadedBlogsPageState extends State<UserUploadedBlogsPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AppUserCubit>().state;
    if (user is AppUserLoggedIn) {
      context.read<BlogBloc>().add(FetchUserBlogs(user.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Uploaded Blogs",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppPallete.gradient1,
        elevation: 3,
      ),
      backgroundColor: AppPallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogDisplaySuccess) {
              final user = context.read<AppUserCubit>().state;
              if (user is AppUserLoggedIn) {
                final userBlogs = state.blogs.where((blog) => blog.posterId == user.user.id).toList();
                if (userBlogs.isEmpty) {
                  return const Center(
                    child: Text(
                      "You haven't uploaded any blogs yet.",
                      style: TextStyle(
                        color: AppPallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: userBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = userBlogs[index];
                    final tileColor = index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                        ? AppPallete.gradient2
                        : AppPallete.gradient3;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: BlogListTile(blog: blog, color: tileColor,
                        onDelete: () {
                          context.read<BlogBloc>().add(DeleteBlog(blog.id));
                        },
                      ),
                    );
                  },
                );
              }
            } else if (state is BlogFailure) {
              return Center(
                child: Text(
                  "Failed to load blogs: ${state.error}",
                  style: const TextStyle(
                    color: AppPallete.errorColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}