class Util {
  static String today() {
    var now = new DateTime.now();
    var result = "${now.year}" +
        "${now.month / 10 == 1 ? now.month : "0${now.month}"}" +
        "${now.day / 10 == 1 ? now.day : "0${now.day}"}" +
        "${now.hour / 10 > 0 ? now.hour : "0${now.hour}"}" +
        "${now.minute / 10 > 0 ? now.minute : "0${now.minute}"}";

    return result;
  }
}
