import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso/models/article.dart';
import 'package:touriso/screens/tab_view/blog/article_card.dart';
import 'package:touriso/utils/firebase_helper.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          title: Text('Blog'),
          centerTitle: false,
          pinned: true,
        ),
        SliverFillRemaining(
          child: StreamBuilder<QuerySnapshot<Object?>>(
            stream: articlesCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              List<Article> articles = snapshot.data!.docs
                  .map((e) => Article.fromFirebase(
                      e.data() as Map<String, dynamic>, e.id))
                  .toList();

              return ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) =>
                    ArticleCard(article: articles[index]),
                separatorBuilder: (context, index) => const Divider(height: 0),
              );
            },
          ),
        ),
      ],
    );
  }
}
