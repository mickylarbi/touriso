import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/booking.dart';
import 'package:touriso/models/site.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/screens/tab_view/bookings/booking_list_tile.dart';
import 'package:touriso/utils/firebase_helper.dart';

class BookingsListPage extends StatefulWidget {
  const BookingsListPage({super.key});

  @override
  State<BookingsListPage> createState() => _BookingsListPageState();
}

class _BookingsListPageState extends State<BookingsListPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        setState(() {});
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Bookings'),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/trips/history');
                },
                icon: const Icon(Icons.history),
              ),
            ],
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: getPendingBookings(),
              builder: (context, AsyncSnapshot<List<List>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: ReloadButton(
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<Booking> bookings = snapshot.data![0] as List<Booking>;
                  List<Activity> activities =
                      snapshot.data![1] as List<Activity>;
                  List<Site> sites = snapshot.data![2] as List<Site>;

                  return ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookings.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      Booking booking = bookings[index];
                      Activity activity = activities.firstWhere(
                          (element) => element.id == booking.activityId);
                      Site site = sites.firstWhere(
                          (element) => element.id == activity.siteId);

                      return BookingListTile(
                        booking: booking,
                        activity: activity,
                        site: site,
                      );
                    },
                  );
                }

                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<List>> getPendingBookings() async {
    //TODO: eg hiking at Kakum as title, picture as leading, date as subtitle and chevron right as trailing
    QuerySnapshot bookingsSnapshot = await bookingsCollection
        .where('clientId', isEqualTo: uid)
        .where('dateTime', isGreaterThan: DateTime.now())
        .get();

    List<Booking> bookings = bookingsSnapshot.docs
        .map(
            (e) => Booking.fromFirebase(e.data() as Map<String, dynamic>, e.id))
        .toList();

    List<Activity> activities = [];

    for (Booking booking in bookings) {
      if (activities
          .where((element) => element.id == booking.activityId)
          .isEmpty) {
        DocumentSnapshot snapshot =
            await activitiesCollection.doc(booking.activityId).get();
        activities.add(Activity.fromFirebase(
            snapshot.data() as Map<String, dynamic>, snapshot.id));
      }
    }

    List<Site> sites = [];

    for (Activity activity in activities) {
      if (sites.where((element) => element.id == activity.siteId).isEmpty) {
        DocumentSnapshot snapshot =
            await sitesCollection.doc(activity.siteId).get();
        sites.add(Site.fromFirebase(
            snapshot.data() as Map<String, dynamic>, snapshot.id));
      }
    }

    return [bookings, activities, sites];
  }
}
