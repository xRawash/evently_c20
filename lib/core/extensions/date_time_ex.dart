import 'package:intl/intl.dart';

extension DateTimeEx on DateTime{
  String get showMonthWeekDay{
    return DateFormat("MMMd").format(this);}
  String get toFormattedDate{
    return DateFormat("dd-MM-yyyy").format(this);}

  String get toFormattedTime => DateFormat('hh:mm a').format(this);
}