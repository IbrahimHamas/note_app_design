import 'package:appdesign/constants/message.dart';

validInput(val, min, max) {
  if (val.length > max) {
    return "$messageInputMax $max";
  }

  if (val.isEmpty) {
    return "$messageInputEmpty";
  }

  if (val.length < min) {
    return "$messageInputMin $min";
  }
}
