/*
 * 날짜 관련 유틸리티 
 */
class DateUtil {
  /* 오늘 날짜 시간 가져오기 */
  static String now(EnumDate enumDate) {
    var now = new DateTime.now();
    var result;
    if (enumDate == EnumDate.YYYYMMDDhhmmss) {
      result = "${now.year}" +
          "${now.month / 10 == 1 ? now.month : "0${now.month}"}" +
          "${now.day / 10 == 1 ? now.day : "0${now.day}"}" +
          "${now.hour / 10 > 0 ? now.hour : "0${now.hour}"}" +
          "${now.minute / 10 > 0 ? now.minute : "0${now.minute}"}" +
          "${now.second / 10 > 0 ? now.second : "0${now.second}"}";
    } else if (enumDate == EnumDate.YYYYMMDD) {
      result = "${now.year}" + "${now.month / 10 == 1 ? now.month : "0${now.month}"}" + "${now.day / 10 == 1 ? now.day : "0${now.day}"}";
    } else if (enumDate == EnumDate.YYYY) {
      result = "${now.year}";
    } else if (enumDate == EnumDate.MM) {
      result = "${now.month / 10 == 1 ? now.month : "0${now.month}"}";
    } else if (enumDate == EnumDate.DD) {
      result = "${now.day / 10 == 1 ? now.day : "0${now.day}"}";
    } else if (enumDate == EnumDate.hh) {
      result = "${now.hour / 10 > 0 ? now.hour : "0${now.hour}"}";
    } else if (enumDate == EnumDate.mm) {
      result = "${now.minute / 10 > 0 ? now.minute : "0${now.minute}"}";
    } else if (enumDate == EnumDate.ss) {
      result = "${now.second / 10 > 0 ? now.second : "0${now.second}"}";
    }

    return result;
  }
}

enum EnumDate { YYYYMMDDhhmmss, YYYYMMDD, YYYY, MM, DD, hh, mm, ss }
