import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtention on DateTime{
  String timeAgo(){
    final curreentDate = DateTime.now();
    if(curreentDate.difference(this).inDays > 1){
      return DateFormat.yMMMd().format(this);
    }
    return timeago.format(this);
  }

}