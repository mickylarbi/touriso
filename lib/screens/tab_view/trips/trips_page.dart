import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touriso/models/booking.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/utils/firebase_helper.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
            )
          ],
        ),
        SliverToBoxAdapter(
          child: StatefulBuilder(builder: (context, setState) {
            return FutureBuilder(
              future: getBookings(),
              builder: (context, AsyncSnapshot<List<Booking>> snapshot) {
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
                  List<Booking> bookings = snapshot.data!;

                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        Booking booking = bookings[index];

                        return ListTile(
                          title: Text(booking.id),
                          subtitle: Text(
                              DateFormat.yMMMMEEEEd().format(booking.dateTime)),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            context
                                .push('/trips/booking_details/${booking.id}');
                          },
                        );
                      },
                    ),
                  );
                }

                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            );
          }),
        )
      ],
    );
  }

  Future<List<Booking>> getBookings() async {
    QuerySnapshot snapshot =
        await bookingsCollection.where('clientId', isEqualTo: uid).get();

    List<Booking> bookings = snapshot.docs
        .map(
            (e) => Booking.fromFirebase(e.data() as Map<String, dynamic>, e.id))
        .toList();

    return bookings;
  }
}
