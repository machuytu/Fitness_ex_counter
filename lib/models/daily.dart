class Daily {
  bool isMonday;
  bool isTuesday;
  bool isWednesday;
  bool isThursday;
  bool isFriday;
  bool isSaturday;
  bool isSunday;
  Daily({
    this.isMonday = false,
    this.isTuesday = false,
    this.isWednesday = false,
    this.isThursday = false,
    this.isFriday = false,
    this.isSaturday = false,
    this.isSunday = false,
  });

  String getString() {
    String monday, tuesday, wednesday, thursday, friday, saturday, sunday;
    if (isMonday == true) {
      monday = " 2";
    } else {
      monday = "";
    }
    if (isTuesday == true) {
      tuesday = " 3";
    } else {
      tuesday = "";
    }
    if (isWednesday == true) {
      wednesday = " 4";
    } else {
      wednesday = "";
    }
    if (isThursday == true) {
      thursday = " 5";
    } else {
      thursday = "";
    }
    if (isFriday == true) {
      friday = " 6";
    } else {
      friday = "";
    }
    if (isSaturday == true) {
      saturday = " 7";
    } else {
      saturday = "";
    }
    if (isSunday == true) {
      sunday = " cn";
    } else {
      sunday = "";
    }
    if (isMonday == false &&
        isTuesday == false &&
        isWednesday == false &&
        isThursday == false &&
        isFriday == false &&
        isSaturday == false &&
        isSunday == false) {
      return "Trống >";
    }
    return monday + tuesday + wednesday + thursday + friday + saturday + sunday;
  }

  List<int> getListDay() {
    List list = [];

    if (isMonday == true) {
      list.add(1);
    }
    if (isTuesday == true) {
      list.add(2);
    }
    if (isWednesday == true) {
      list.add(3);
    }
    if (isThursday == true) {
      list.add(4);
    }
    if (isFriday == true) {
      list.add(5);
    }
    if (isSaturday == true) {
      list.add(6);
    }
    if (isSunday == true) {
      list.add(7);
    }

    return list;
  }
}
