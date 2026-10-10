import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/extensions/date_time_ex.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventModel;
    bool isOwner = event.ownerId == UserModel.loggedInUser!.id;
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 16),
        title: Text(
          AppLocalizations.of(context)!.eventDetails,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyActions: true,
        actions: isOwner ? [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/updateEvent', arguments: event);
              },
              style: IconButton.styleFrom(
                  foregroundColor: ColorsManager.darkBlue
              ),
              icon: Icon(Icons.mode_edit_outline_outlined),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () async {
                await FirebaseServices.deleteEvent(event);
                Fluttertoast.showToast(msg: "Event Deleted Successfully",
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(
                foregroundColor: Colors.red
              ),
              icon: Icon(Icons.delete_outline),
            ),
          ),
        ]: null ,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(16),
                child: Image(image: AssetImage(event.category.image)),
              ),
              SizedBox(height: 16),
              Text(event.title, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.calendar_month_rounded),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.dateTime.showMonthWeekDay,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(
                          event.dateTime.toFormattedTime,
                          style: Theme.of(context).textTheme.displaySmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Description",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  event.description,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
