import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/event_item.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/view_models/fav_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FavViewModel favViewModel = Provider.of<FavViewModel>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _searchController,
              hintText: AppLocalizations.of(context)!.searchForEvent,
              suffixIcon: const Icon(Icons.search),
            ),
            Expanded(
              child: StreamBuilder<List<EventModel>>(
                stream: favViewModel.getFavEventsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  List<EventModel> favEvents =
                      favViewModel.filterEvents(snapshot.data ?? []);

                  if (favEvents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: ColorsManager.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            favViewModel.searchQuery.isNotEmpty
                                ? "No events found"
                                : "No favorite events added yet",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: ColorsManager.grey,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) => EventItem(
                      event: favEvents[index],
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: favEvents.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
