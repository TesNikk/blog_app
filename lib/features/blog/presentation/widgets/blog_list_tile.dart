import 'package:flutter/material.dart';
import '../../domain/entities/blog.dart';
import '../pages/blog_viewer_page.dart';

class BlogListTile extends StatelessWidget {
  final Blog blog;
  final Color color; // Add color parameter
  final VoidCallback onDelete;

  const BlogListTile({super.key, required this.blog, required this.color, required this.onDelete});
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Blog"),
        content: const Text("Are you sure you want to delete this blog?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onDelete(); // Call delete function
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDelete(context),
        ),
      ),

    );
  }
}
