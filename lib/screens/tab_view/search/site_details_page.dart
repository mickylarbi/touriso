import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/site.dart';
import 'package:touriso/screens/shared/image_viewer.dart';
import 'package:touriso/screens/tab_view/search/explore_page.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';
import 'package:touriso/utils/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteDetailsPage extends StatelessWidget {
  const SiteDetailsPage({super.key, required this.site});
  final Site site;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            site.name,
            // style: Theme.of(context)
            //     .textTheme
            //     .headlineSmall!
            //     .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location:', style: labelMedium(context)),
                    Text(site.location),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton.icon(
                        onPressed: () async {
                          Uri mapUri =
                              Uri.https('www.google.com', '/maps/search/', {
                            'api': '1',
                            'query':
                                '${site.geoLocation.latitude},${site.geoLocation.longitude}'
                          });

                          try {
                            if (await canLaunchUrl(mapUri)) {
                              await launchUrl(mapUri);
                            } else {
                              showAlertDialog(context);
                            }
                          } catch (e) {
                            showAlertDialog(context);
                          }
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('View on map'),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Images',
                      style: titleLarge(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: site.imageUrls.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                      imageUrl: site.imageUrls[index])));
                        },
                        child: Image.network(site.imageUrls[index]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 48),
                child: Text(
                  'Activities',
                  style: titleLarge(context),
                ),
              ),
              SizedBox(
                height: 300,
                child: activitiesCarousel(),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(site.description),
              ),
            ],
          ),
        ),
      ],
    );
  }

  activitiesCarousel() {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: activitiesCollection.where('siteId', isEqualTo: site.id).get(),
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
}
