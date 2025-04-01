import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../blog/presentation/bloc/blog_bloc.dart';
import '../../../blog/presentation/pages/blog_page.dart';
import '../../../blog/presentation/pages/user_uploaded_blogs_page.dart';
import '../bloc/auth_bloc.dart';
import '../pages/login_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppPallete.backgroundColor,
      child: BlocConsumer<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserLoggedIn) {
            // Force rebuild when user state changes
            Future.microtask(() => setState(() {}));
          }
        },
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            final user = state.user;

            if (user.name.isEmpty) {
              // Trigger a refresh of user data
              context.read<AuthBloc>().add(AuthIsUserLoggedIn());
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: AppPallete.gradient1,
                  ),
                  accountName: Text(
                    user.name,
                    style: const TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    user.email,
                    style: const TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppPallete.whiteColor,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppPallete.gradient1,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.article, color: AppPallete.whiteColor),
                  title: const Text(
                    'Uploaded Blogs',
                    style: TextStyle(color: AppPallete.whiteColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserUploadedBlogsPage()),
                    ).then((_) {
                      // Refresh all blogs when returning to BlogPage
                      if (Navigator.of(context).canPop()) {
                        context.read<BlogBloc>().add(BlogGetAllBlogs());
                      }
                    });
                  },
                ),
                const Divider(color: AppPallete.borderColor),
                ListTile(
                  leading:
                      const Icon(Icons.logout, color: AppPallete.errorColor),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: AppPallete.errorColor),
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLogOut());
                    context
                        .read<AppUserCubit>()
                        .updateUser(null); // Reset user state
                    Navigator.of(context).pushAndRemoveUntil(
                      LoginPage.route(),
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          }
          return const Center(
            child: Text(
              'No user logged in',
              style: TextStyle(color: AppPallete.whiteColor),
            ),
          );
        },
      ),
    );
  }
}
