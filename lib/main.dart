import 'package:flutter/material.dart';
import 'models/post.dart';
import 'services/api_service.dart';

void main() => runApp(ApiPostsApp());

class ApiPostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Posts App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = ApiService.fetchPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _futurePosts = ApiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSONPlaceholder Posts"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final posts = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(post.body),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
