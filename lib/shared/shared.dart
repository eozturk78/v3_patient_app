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
    DateTime parseDate;
    parseDate = new DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd.MM.yy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  formatDateTime(String date) {
    var d = DateTime.parse(date).toLocal();
    print(d);
    var listData = d.toString().split(" ");
    var dateList = listData[0].split("-");
    var time = listData[1].substring(0, 5);
    var day = dateList[2];
    var month = dateList[1];
    var year = dateList[0];
    var outputDate = '$day.$month.$year $time';
    return outputDate;
  }

  formatDateImc(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);

    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd.MM.yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}
