import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/site.dart';
import 'package:touriso/screens/shared/activity_details_page.dart';
import 'package:touriso/screens/tab_view/search/site_details_page.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/firebase_helper.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find your\nnext trip',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.push('/explore/search');
                },
                child: Hero(
                  tag: searchHeroTag,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Search',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Popular sites',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 300,
                child: sitesCarousel(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Popular activities',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 300,
                child: activitiesCarousel(),
              ),
              // SizedBox(
              //   height: 200,
              //   child: PageView.builder(
              //     controller: PageController(viewportFraction: 0.7),
              //     itemCount: Colors.primaries.length,
              //     itemBuilder: (context, index) => Container(
              //       //  width: 200,
              //       decoration: BoxDecoration(
              //         color: Colors.primaries[index],
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //   ),
              // )
              //TODO: try pageview with viewport fraction things
            ],
          ),
        ),
      ],
    );
  }

  activitiesCarousel() {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: activitiesCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              children: [
                const Text('Could not retrieve activities'),
                TextButton.icon(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload'),
                )
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<Activity> activities = (snapshot.data! as QuerySnapshot)
                .docs
                .map((e) => Activity.fromFirebase(
                    e.data() as Map<String, dynamic>, e.id))
                .toList();

            return activities.isEmpty
                ? const Center(
                    child: Text(
                      'No activities found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    scrollDirection: Axis.horizontal,
                    itemCount: activities.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) => ActivityCard(
                      activity: activities[index],
                    ),
                  );
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  sitesCarousel() {
    return FutureBuilder(
      future: sitesCollection.get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              const Text('Could not retrieve sites'),
              TextButton.icon(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reload'),
              )
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<Site> sites = (snapshot.data! as QuerySnapshot)
              .docs
              .map((e) =>
                  Site.fromFirebase(e.data() as Map<String, dynamic>, e.id))
              .toList();

          return sites.isEmpty
              ? const Center(
                  child: Text(
                    'No sites found',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  scrollDirection: Axis.horizontal,
                  itemCount: sites.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) => SiteCard(site: sites[index]),
                );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SiteCard extends StatelessWidget {
  const SiteCard({
    super.key,
    required this.site,
  });
  final Site site;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SiteDetailsPage(site: site)));
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30)
          ],
          image: site.imageUrls.isEmpty
              ? null
              : DecorationImage(
                  image: NetworkImage(site.imageUrls[0]),
                  fit: BoxFit.cover,
                ),
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: site.imageUrls.isEmpty
                ? null
                : LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.05),
                      Colors.black.withOpacity(.05),
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                site.name,
                maxLines: 3,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                site.location,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
  });
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivityDetailsPage(activity: activity)));
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30)
          ],
          image: activity.imageUrls.isEmpty
              ? null
              : DecorationImage(
                  image: NetworkImage(activity.imageUrls[0]),
                  fit: BoxFit.cover,
                ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: activity.imageUrls.isEmpty
                ? null
                : LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.05),
                      Colors.black.withOpacity(.05),
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.name,
                maxLines: 3,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                activity.duration.toString(),
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$ghanaCedi ${activity.price}',
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
