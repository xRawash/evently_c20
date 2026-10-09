import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/event_item.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late TextEditingController _searchController;
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener((){
      setState(() {
        searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _searchController,
              hintText: AppLocalizations.of(context)!.searchForEvent,
              suffixIcon: Icon(Icons.search),
            ),
            Expanded(
              child: StreamBuilder(stream: FirebaseServices.getFavEventsRealTimeFromFireStore(), builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return Center(child: Text("Something went wrong"));
                }
                List<EventModel> favEvents = snapshot.data!;
                if(searchQuery.isNotEmpty){
                  favEvents = favEvents.where((event) => event.title.toLowerCase().contains(searchQuery)).toList();
                }
                if (favEvents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: ColorsManager.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty
                              ? "No events found"
                              : "No favorite events added yet",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorsManager.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) => EventItem(
                    event: favEvents[index],
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount:favEvents.length,
                );
              })
            ),
          ],
        ),
      ),
    );
  }
}
