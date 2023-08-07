import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso/models/client.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';
import 'package:touriso/utils/text_styles.dart';

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

            return RefreshIndicator.adaptive(
              onRefresh: () async {
                setState(() {});
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  const SliverAppBar(
                    title: Text('Profile'),
                    centerTitle: false,
                    pinned: true,
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
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 48,
                                backgroundImage: client.pictureUrl == null
                                    ? null
                                    : NetworkImage(client.pictureUrl!),
                                child: client.pictureUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    final ImagePicker picker = ImagePicker();

                                    XFile? pickedImage = await picker.pickImage(
                                        source: ImageSource.gallery);

                                    if (pickedImage != null) {
                                      showLoadingDialog(context);

                                      await picturesRef(uid).putData(
                                          await pickedImage.readAsBytes());

                                      await clientsCollection.doc(uid).update({
                                        'pictureUrl': await picturesRef(uid)
                                            .getDownloadURL()
                                      });

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();

                                      setState(() {});
                                    }
                                  } catch (e) {
                                    print(e);
                                    showAlertDialog(context);
                                  }
                                },
                                child: Text(
                                    '${client.pictureUrl == null ? 'Choose' : 'Change'} picture'),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    showLoadingDialog(context);

                                    await picturesRef(uid).delete();
                                    await clientsCollection
                                        .doc(uid)
                                        .update({'pictureUrl': null});

                                    Navigator.of(context, rootNavigator: true)
                                        .pop();

                                    setState(() {});
                                  } catch (e) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    showAlertDialog(context,
                                        message: 'Error deleting picture');
                                  }
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.withOpacity(.1),
                                    foregroundColor: Colors.red),
                                child: const Text('Delete picture'),
                              )
                            ],
                          ),
                        ),
                        const Divider(height: 48),
                        ProfileDetailListTile(
                          currentValue: client.firstName,
                          labelText: 'First name',
                          firebaseLabel: 'firstName',
                          setState: setState,
                        ),
                        const Divider(height: 20),
                        ProfileDetailListTile(
                          currentValue: client.otherNames,
                          labelText: 'Other names',
                          firebaseLabel: 'otherNames',
                          setState: setState,
                        ),
                        const Divider(height: 20),
                        ProfileDetailListTile(
                          currentValue: client.email,
                          labelText: 'Email',
                          firebaseLabel: 'email',
                          setState: setState,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

class ProfileDetailListTile extends StatefulWidget {
  const ProfileDetailListTile({
    super.key,
    required this.currentValue,
    required this.labelText,
    required this.setState,
    required this.firebaseLabel,
  });

  final String currentValue;
  final String labelText;
  final String firebaseLabel;
  final void Function(void Function()) setState;

  @override
  State<ProfileDetailListTile> createState() => _ProfileDetailListTileState();
}

class _ProfileDetailListTileState extends State<ProfileDetailListTile> {
  final TextEditingController controller = TextEditingController();
  ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (controller.text.isEmpty || controller.text == widget.currentValue) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.labelText}:', style: bodySmall(context)),
            Text(widget.currentValue),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            controller.text = widget.currentValue;

            await showFormDialog(
              context,
              ListView(
                shrinkWrap: true,
                children: [
                  CustomTextFormField(
                    controller: controller,
                    hintText: widget.labelText,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      StatefulLoadingButton(
                        buttonEnabledNotifier: buttonEnabledNotifier,
                        onPressed: () async {
                          try {
                            await clientsCollection
                                .doc(auth.currentUser!.uid)
                                .update({
                              widget.firebaseLabel: controller.text.trim()
                            });

                            Navigator.of(context, rootNavigator: true).pop();
                            widget.setState(() {});
                            print('here');
                          } catch (e) {
                            print(e);
                            showAlertDialog(context);
                          }
                        },
                        child: Text('Change ${widget.labelText.toLowerCase()}'),
                      ),
                    ],
                  ),
                  if (widget.labelText == 'Email') const SizedBox(height: 20),
                  if (widget.labelText == 'Email')
                    Text('Email for login will remain the same',
                        style: bodySmall(context)),
                ],
              ),
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    buttonEnabledNotifier.dispose();

    super.dispose();
  }
}
