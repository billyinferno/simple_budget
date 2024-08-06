class MyDateUtils {
  static int monthDifference({
    required DateTime startDate,
    required DateTime endDate
  }) {
    // ensure start date is before end date
    assert(startDate.isBefore(endDate));

    // generate the loop date
    DateTime loopDate = DateTime(startDate.year, startDate.month, 1);
    DateTime loopEndDate = DateTime(endDate.year, (endDate.month + 1), 1);
    int monthDiff = 0;

    while(loopDate.isBefore(loopEndDate)) {
      monthDiff = monthDiff + 1;
      loopDate = DateTime(startDate.year, startDate.month + monthDiff, 1);
    }

    return monthDiff;
  }
}