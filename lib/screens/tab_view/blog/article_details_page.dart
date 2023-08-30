import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/article.dart';
import 'package:touriso/models/client.dart';
import 'package:touriso/models/comment.dart';
import 'package:touriso/models/site.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/tab_view/blog/blog_image_grid.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';
import 'package:touriso/utils/text_styles.dart';

class ArticleDetailsPage extends StatelessWidget {
  const ArticleDetailsPage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    articlesCollection.doc(article.id).update({
      'views': FieldValue.arrayUnion([uid])
    });

    String sitesLength = article.siteIds.isEmpty
        ? ''
        : '${article.siteIds.length} site${article.siteIds.length == 1 ? '' : 's'}';
    String activitiesLength = article.activityIds.isEmpty
        ? ''
        : '${article.activityIds.length} activit${article.activityIds.length == 1 ? 'y' : 'ies'}';

    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          title: Text('Article'),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: titleMedium(context),
                    ),
                    Row(
                      children: [
                        FutureBuilder<DocumentSnapshot<Object?>>(
                          future: writersCollection.doc(article.writerId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                  'By ${(snapshot.data!.data() as Map<String, dynamic>)['name']}');
                            }
                            return const Text('');
                          },
                        ),
                        Expanded(
                          child: Text(
                            DateFormat.yMMMEd().format(
                                article.lastEdited ?? article.dateTimePosted),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(article.content),
                    const SizedBox(height: 12),
                    if (article.siteIds.isNotEmpty &&
                        article.activityIds.isNotEmpty)
                      InkWell(
                        onTap: () {
                          showFormDialog(
                            context,
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (article.siteIds.isNotEmpty)
                                    const Text('Sites'),
                                  if (article.siteIds.isNotEmpty)
                                    const SizedBox(height: 10),
                                  FutureBuilder<List<Site>>(
                                    future: getSitesDetails(),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text('Something went wrong'),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        List<Site> sites = snapshot.data!;

                                        return ListView.separated(
                                          shrinkWrap: true,
                                          primary: false,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: sites.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(height: 10);
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title: Text(sites[index].name),
                                              subtitle:
                                                  Text(sites[index].location),
                                            );
                                          },
                                        );
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    },
                                  ),
                                  const Divider(height: 40),
                                  if (article.activityIds.isNotEmpty)
                                    const Text('Activities'),
                                  if (article.activityIds.isNotEmpty)
                                    const SizedBox(height: 10),
                                  FutureBuilder<List<Activity>>(
                                    future: getActivitiesDetails(),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text('Something went wrong'),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        List<Activity> activities =
                                            snapshot.data!;

                                        return ListView.separated(
                                          shrinkWrap: true,
                                          primary: false,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: activities.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(height: 10);
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title:
                                                  Text(activities[index].name),
                                              subtitle: Text(
                                                activities[index]
                                                    .duration
                                                    .toString(),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_pin),
                              const SizedBox(width: 5),
                              Text('$sitesLength $activitiesLength'.trim()),
                            ],
                          ),
                        ),
                      ),
                    if (article.imageUrls.isNotEmpty)
                      const SizedBox(height: 12),
                    if (article.imageUrls.isNotEmpty)
                      const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BlogImageGrid(imageUrls: article.imageUrls),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: articlesCollection.doc(article.id).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    Article article = Article.fromFirebase(
                        snapshot.data!.data() as Map<String, dynamic>,
                        snapshot.data!.id);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  articlesCollection.doc(article.id).update(
                                    {
                                      'likes': article.likes.contains(uid)
                                          ? FieldValue.arrayRemove([uid])
                                          : FieldValue.arrayUnion([uid])
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      article.likes.contains(uid)
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: article.likes.contains(uid)
                                          ? Colors.red
                                          : null,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('${article.likes.length}')
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  String comment = '';
                                  showFormDialog(
                                    context,
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextFormField(
                                          controller: TextEditingController(),
                                          hintText: 'Comment',
                                          onChanged: (val) {
                                            comment = val;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        FilledButton(
                                          onPressed: () {
                                            if (comment.isNotEmpty) {
                                              context.pop();
                                              showLoadingDialog(context);

                                              try {
                                                articlesCollection
                                                    .doc(article.id)
                                                    .update({
                                                  'comments':
                                                      FieldValue.arrayUnion([
                                                    Comment(
                                                            userId: uid,
                                                            content: comment)
                                                        .toMap()
                                                  ])
                                                });

                                                context.pop();
                                              } catch (e) {
                                                showAlertDialog(context);
                                              }
                                            }
                                          },
                                          child: const Text('Add comment'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.chat_bubble_outline_rounded),
                                    const SizedBox(width: 4),
                                    Text('${article.comments.length}')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        if (article.comments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Comments',
                              style: titleMedium(context),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          padding: const EdgeInsets.only(left: 32),
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Comment comment = article.comments[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<DocumentSnapshot<Object?>>(
                                  future: clientsCollection
                                      .doc(comment.userId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Client client = Client.fromFirebase(
                                          snapshot.data!.data()
                                              as Map<String, dynamic>,
                                          snapshot.data!.id);
                                      return Text(client.name);
                                    }

                                    return const Text('');
                                  },
                                ),
                                Text(comment.content),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: article.comments.length,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<Site>> getSitesDetails() async {
    List<Site> sites = [];

    for (String siteId in article.siteIds) {
      DocumentSnapshot siteSnapshot = await sitesCollection.doc(siteId).get();

      sites.add(Site.fromFirebase(
          siteSnapshot.data() as Map<String, dynamic>, siteSnapshot.id));
    }

    return sites;
  }

  Future<List<Activity>> getActivitiesDetails() async {
    List<Activity> activities = [];

    for (String activityId in article.activityIds) {
      DocumentSnapshot activitySnapshot =
          await activitiesCollection.doc(activityId).get();

      activities.add(Activity.fromFirebase(
          activitySnapshot.data() as Map<String, dynamic>,
          activitySnapshot.id));
    }

    return activities;
  }
}
