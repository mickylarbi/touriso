import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso/models/activity.dart';
import 'package:touriso/models/site.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/tab_view/search/explore_page.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/firebase_helper.dart';
import 'package:touriso/utils/text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  ValueNotifier<bool> searchNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      searchNotifier.value = !searchNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: searchPrep(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: searchHeroTag,
                        child: CustomTextFormField(
                          autoFocus: true,
                          controller: searchController,
                          hintText: 'Search sites, activities, locations',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            icon: const Icon(Icons.clear, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    ValueListenableBuilder(
                      valueListenable: searchNotifier,
                      builder: (context, value, child) {
                        List<Site> hits = ((snapshot.data! as List)[0]
                                as List<Site>)
                            .where((element) => element.name
                                .trim()
                                .toLowerCase()
                                .contains(
                                    searchController.text.trim().toLowerCase()))
                            .toList();

                        if (searchController.text.trim().isEmpty) {
                          return Container();
                        }

                        return hits.isEmpty
                            ? const Center(
                                child: Text(
                                  'No sites found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sites',
                                    style: titleLarge(context),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(24),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: hits.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 10),
                                      itemBuilder: (context, index) =>
                                          SiteCard(site: hits[index]),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 48),
                    ValueListenableBuilder(
                      valueListenable: searchNotifier,
                      builder: (context, bool value, child) {
                        if (searchController.text.trim().isEmpty) {
                          return Container();
                        }
                        List<Activity> hits = ((snapshot.data! as List)[1]
                                as List<Activity>)
                            .where((element) => element.name
                                .trim()
                                .toLowerCase()
                                .contains(
                                    searchController.text.trim().toLowerCase()))
                            .toList();

                        return hits.isEmpty
                            ? const Center(
                                child: Text(
                                  'No activities found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Activity',
                                    style: titleLarge(context),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(24),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: hits.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 10),
                                      itemBuilder: (context, index) =>
                                          ActivityCard(
                                        activity: hits[index],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 48),
                    ValueListenableBuilder(
                      valueListenable: searchNotifier,
                      builder: (context, value, child) {
                        List<Site> hits = ((snapshot.data! as List)[0]
                                as List<Site>)
                            .where((element) => element.location
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()))
                            .toList();

                        if (searchController.text.trim().isEmpty) {
                          return Container();
                        }

                        return hits.isEmpty
                            ? const Center(
                                child: Text(
                                  'No locations found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Locations',
                                    style: titleLarge(context),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(24),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: hits.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 10),
                                      itemBuilder: (context, index) =>
                                          SiteCard(site: hits[index]),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              ),
              //TODO: refresh indicators
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}

searchPrep() async {
  sitesCollection.get();

  List<Site> sites = (await sitesCollection.get())
      .docs
      .map((e) => Site.fromFirebase(e.data() as Map<String, dynamic>, e.id))
      .toList();

  List<Activity> activities = (await activitiesCollection.get())
      .docs
      .map((e) => Activity.fromFirebase(e.data() as Map<String, dynamic>, e.id))
      .toList();

  return [sites, activities];
}
