final class StringUtil {
  static List<String> dayNames = ['Mo','Di','Mi','Do','Fr','Sa','So'];

  static String localizedDayName(int dayOfWeek) => dayNames[dayOfWeek % 7];

  static String positionalDayData(DateTime date) {
    int difference = DateTime.now().difference(date).inDays;
    DateTime firstOfYear = DateTime(date.year);
    switch (difference) {
      default: {
        return 'Today, ' + date.toString() + ', '
            + firstOfYear.difference(date).inDays.toString() + 'th day of the year.';
      }
    }
  }
}