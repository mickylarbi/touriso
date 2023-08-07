import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/booking.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.activity});
  final Activity activity;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ValueNotifier<DateTime?> dateTimeNotifier = ValueNotifier(null);
  final ValueNotifier<bool> isAloneNotifier = ValueNotifier(false);
  final TextEditingController numberOfPeopleController =
      TextEditingController();

  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (dateTimeNotifier.value == null ||
        (!isAloneNotifier.value &&
            int.tryParse(numberOfPeopleController.text.trim()) == null)) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    dateTimeNotifier.addListener(() {
      setButtonState();
    });
    isAloneNotifier.addListener(() {
      setButtonState();
    });
    numberOfPeopleController.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(title: Text('Book Trip'), pinned: true),
        SliverToBoxAdapter(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              StatefulBuilder(builder: (context, setState) {
                return FutureBuilder(
                  future: getActivityFromId(),
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

                    if (snapshot.connectionState == ConnectionState.done) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.name),
                              const SizedBox(width: 4),
                              Text(snapshot.data!.duration.toString()),
                              const SizedBox(width: 4),
                              Text('$ghanaCedi ${snapshot.data!.price}'),
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
              ValueListenableBuilder(
                valueListenable: dateTimeNotifier,
                builder: (context, DateTime? value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (value != null)
                        Text(DateFormat.yMMMMEEEEd().format(value)),
                      if (value != null) const Spacer(),
                      TextButton(
                        onPressed: () async {
                          DateTime? result = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate:
                                DateTime.now().add(const Duration(days: 1)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 31)),
                          );

                          if (result != null) {
                            dateTimeNotifier.value = result;
                          }
                        },
                        child:
                            Text('${value == null ? 'Choose' : 'Change'} date'),
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 48),
              ValueListenableBuilder(
                valueListenable: isAloneNotifier,
                builder: (context, bool value, child) {
                  return Column(
                    children: [
                      if (!value)
                        Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text('How many in your party?'),
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                controller: numberOfPeopleController,
                                hintText: '1',
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          isAloneNotifier.value = !value;
                        },
                        child: Row(
                          children: [
                            Checkbox.adaptive(
                              value: value,
                              onChanged: (val) {
                                isAloneNotifier.value = val!;
                              },
                            ),
                            const SizedBox(width: 10),
                            const Text('I am coming alone'),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
              const Divider(height: 48),
              StatefulLoadingButton(
                buttonEnabledNotifier: buttonEnabledNotifier,
                onPressed: () async {
                  await showConfirmationDialog(
                    context,
                    message: 'Proceed to book trip?',
                    confirmFunction: () async {
                      try {
                        String companyId = ((await sitesCollection
                                .doc(widget.activity.siteId)
                                .get())
                            .data()! as Map<String, dynamic>)['companyId'];

                        DocumentReference reference =
                            await bookingsCollection.add(
                          Booking.empty(
                            clientId: uid,
                            activityId: widget.activity.id,
                            companyId: companyId,
                            dateTime: dateTimeNotifier.value!,
                            numberOfPeople: isAloneNotifier.value
                                ? 1
                                : int.parse(
                                    numberOfPeopleController.text.trim()),
                          ).toFirebase(),
                        );

                        context.go('/trips/booking_details/${reference.id}');
                      } catch (e) {
                        showAlertDialog(context);
                      }
                    },
                  );
                },
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Activity> getActivityFromId() async {
    DocumentSnapshot result =
        await activitiesCollection.doc(widget.activity.id).get();

    return Activity.fromFirebase(
        result.data()! as Map<String, dynamic>, result.id);
  }

  @override
  void dispose() {
    dateTimeNotifier.dispose();
    isAloneNotifier.dispose();
    numberOfPeopleController.dispose();

    super.dispose();
  }
}
