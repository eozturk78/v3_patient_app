import 'package:intl/intl.dart';

class Shared {
  var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
  emailValidator(text) {
    if (text == null || text.isEmpty) {
      return 'This field is required';
    } else if (!(text.contains('@')) && text.isNotEmpty) {
      return "Enter valid email.";
    }
    return null;
  }

  textValidator(text) {
    if (text == null || text?.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  numberFormatter(double? number) {
    if (number == null) return "0,0000";
    var formatter = NumberFormat('#,###.0000');
    var result = formatter.format(number);
    var pureNumber =
        result.substring(0, result.indexOf('.')).replaceAll(',', '.');
    var decimal = result.toString().substring(result.indexOf('.') + 1);
    if (pureNumber == "") pureNumber = "0";
    return "$pureNumber,$decimal";
  }

  prePareNumberForRequest(String number) {
    return number.replaceAll(".", "").replaceAll(",", ".");
  }

  getBaseName(String url) {
    return url.toString().substring(url.lastIndexOf('/') + 1);
  }

  formatDate(String date) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd.MM.yy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}
