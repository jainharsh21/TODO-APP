import 'package:intl/intl.dart';

String dateFormatted()
{
  var date = DateTime.now();

  var formatter = new DateFormat("EEE,MMM d,yy");
  String formatted = formatter.format(date);
  return formatted;
}