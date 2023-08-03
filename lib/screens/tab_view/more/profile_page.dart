import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso/models/client.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: getClient(),
        builder: (context, AsyncSnapshot<Client> snapshot) {
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
            Client client = snapshot.data!;

            return CustomScrollView(
              slivers: <Widget>[
                const SliverAppBar(
                  title: Text('Profile'),
                  centerTitle: false,
                ),
                SliverToBoxAdapter(
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      Center(
                        child: Column(
                          children: [
                            if (client.pictureUrl != null)
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(client.pictureUrl!),
                              ),
                            if (client.pictureUrl != null)
                              const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                final ImagePicker picker = ImagePicker();

                                picker
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) async {
                                  if (value != null) {
                                    await picturesRef(uid)
                                        .putData(await value.readAsBytes());
                                  }
                                }).onError((error, stackTrace) {
                                  showAlertDialog(context);
                                });
                              },
                              child: Text(
                                  '${client.pictureUrl == null ? 'Choose' : 'Change'} picture'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      );
    });
  }

  Future<Client> getClient() async {
    DocumentSnapshot clienTSnapshot = await clientsCollection.doc(uid).get();

    Client client = Client.fromFirebase(
        clienTSnapshot.data()! as Map<String, dynamic>, clienTSnapshot.id);

    return client;
  }
}
