import 'package:evently_app_abbas/core/extensions/date_time_ex.dart';
import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem extends StatefulWidget {
   EventItem({super.key, required this.event});
EventModel event;

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {

  @override
  Widget build(BuildContext context) {
    bool isFavourite = UserModel.loggedInUser!.favEvents.contains(widget.event.id);
    return Container(
      width: double.infinity,
      height: 193,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(widget.event.category.image)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorsManager.grey, width: 1)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.event.dateTime.showMonthWeekDay, style:Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            Spacer(),
            Card(

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.event.title, style: Theme
                          .of(context)
                          .textTheme.headlineSmall),
                    ),
                    InkWell(onTap: () async {
                      setState(() {
                        isFavourite = !isFavourite;
                        if(isFavourite) {
                          FirebaseServices.addEventToFav(widget.event);
                        }else {
                          FirebaseServices.removeEventFromFav(widget.event);
                        }
                      });
                    },child: Icon(isFavourite? Icons.favorite_outlined : Icons.favorite_outline)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
