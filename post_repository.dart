import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:class_work/model/post.dart';

class PostRepository {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/posts";

  /// 1. Fetches a list of all posts
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonData = json.decode(decodedBody) as List<dynamic>;

        return jsonData.map((item) {
          return Post.fromJson(item as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchPosts: $e");
      throw Exception("Failed to load posts: $e");
    }
  }

  /// 2. Fetches a single post by ID
  Future<Post> fetchPostById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(decodedBody) as Map<String, dynamic>;

        return Post.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception("Post not found");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchPostById: $e");
      throw Exception("Failed to fetch post: $e");
    }
  }

  /// 3. Creates a new post (POST request)
  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': userId,
        }),
      );

      if (response.statusCode == 201) {
        // Status 201 means "Created" successfully on the server
        print('Post created successfully on the server!');
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in createPost: $e");
      throw Exception('Network error: $e');
    }
  }
}