import 'package:flutter/material.dart';
import '../../domain/entities/blog.dart';
import '../pages/blog_viewer_page.dart';

class BlogListTile extends StatelessWidget {
  final Blog blog;
  final Color color; // Add color parameter

  const BlogListTile({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: color, // Apply the color
      child: ListTile(
        title: Text(
          blog.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          blog.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(context, BlogViewerPage.route(blog));
        },
      ),
    );
  }
}
