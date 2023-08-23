import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/booking.dart';
import 'package:touriso/models/site.dart';

class BookingListTile extends StatelessWidget {
  const BookingListTile({
    super.key,
    required this.booking,
    required this.activity,
    required this.site,
  });

  final Booking booking;
  final Activity activity;
  final Site site;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: activity.imageUrls.isEmpty
            ? Container(
                height: 48,
                width: 48,
                color: Colors.grey[300],
              )
            : Image.network(
                activity.imageUrls[0],
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
      ),
      title: Text('${activity.name} at ${site.name}'),
      subtitle: Text(DateFormat.yMMMMEEEEd().format(booking.dateTime)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
      ),
      onTap: () {
        context.push('/trips/booking_details/${booking.id}');
      },
    );
  }
}
