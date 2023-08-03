import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/booking.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';
import 'package:touriso/utils/text_styles.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: getBooking(),
        builder: (context, AsyncSnapshot<Booking> snapshot) {
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
            Booking booking = snapshot.data!;

            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(booking.id),
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      StatefulBuilder(builder: (context, setState) {
                        return FutureBuilder(
                          future: getActivityFromId(booking.activityId),
                          builder: (context, AsyncSnapshot<Activity> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: ReloadButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                ),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: snapshot.data!.imageUrls.isEmpty
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            color: Colors.grey[300],
                                          )
                                        : Image.network(
                                            snapshot.data!.imageUrls[0],
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data!.name),
                                      const SizedBox(width: 4),
                                      Text(snapshot.data!.duration.toString()),
                                      const SizedBox(width: 4),
                                      Text(
                                          '$ghanaCedi ${snapshot.data!.price}'),
                                    ],
                                  ),
                                ],
                              );
                            }

                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          },
                        );
                      }),
                      const Divider(height: 48),
                      // Text(
                      //   'Details',
                      //   style: titleMedium(context),
                      // ),
                      // const SizedBox(height: 10),
                      Text(DateFormat.yMMMMEEEEd().format(booking.dateTime)),
                      const SizedBox(height: 20),
                      Text(
                        'Number of people:',
                        style: labelMedium(context).copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(booking.numberOfPeople.toString()),
                      const Divider(height: 48),
                      TextButton.icon(
                        onPressed: () {
                          showConfirmationDialog(
                            context,
                            message:
                                'Cancel booking?\nThis action is irreversible',
                            confirmFunction: () async {
                              showLoadingDialog(context);
                              try {
                                await bookingsCollection
                                    .doc(bookingId)
                                    .delete();

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                context.go('/trips');
                              } catch (e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                showAlertDialog(context);
                              }
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(.2),
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Cancel booking'),
                      ),
                    ],
                  ),
                )
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      );
    });
  }

  Future<Activity> getActivityFromId(activityId) async {
    DocumentSnapshot result = await activitiesCollection.doc(activityId).get();

    return Activity.fromFirebase(
        result.data()! as Map<String, dynamic>, result.id);
  }

  Future<Booking> getBooking() async {
    DocumentSnapshot result = await bookingsCollection.doc(bookingId).get();

    return Booking.fromFirebase(
        result.data()! as Map<String, dynamic>, result.id);
  }
}
