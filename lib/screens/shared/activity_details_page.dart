import 'package:flutter/material.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/screens/shared/image_viewer.dart';
import 'package:touriso/screens/tab_view/bookings/booking_page.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/text_styles.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(activity.name),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration:',
                          style: labelMedium(context).copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(activity.duration.toString()),
                        const SizedBox(height: 20),
                        Text(
                          'Price:',
                          style: labelMedium(context).copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('$ghanaCedi ${activity.price}'),
                        const SizedBox(height: 20),
                        if (activity.location != null &&
                            activity.location!.isNotEmpty)
                          Text(
                            'Location:',
                            style: labelMedium(context).copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (activity.location != null &&
                            activity.location!.isNotEmpty)
                          Text(activity.location!),
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
                      itemCount: activity.imageUrls.length,
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
                                          imageUrl:
                                              activity.imageUrls[index])));
                            },
                            child: Image.network(activity.imageUrls[index]),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      activity.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  FutureBuilder(
                    future: Future(() {}),
                    builder: (context, snapshot) {
                      return Container();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingPage(activity: activity)));
              },
              child: const Row(
                children: [Text('BOOK'), Spacer(), Icon(Icons.chevron_right)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
