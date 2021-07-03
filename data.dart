enum Subject { MATH, SCIENCE, ENGLISH, HISTORY, LANGUAGE, OTHER }

class Date {
  int day;
  int month;
  int year;

  Date(int month, int day, int year) {
    this.day = day;
    this.month = month;
    this.year = year;
  }

  String toString() {
    String m = (month >= 10) ? '$month' : '0$month';
    String d = (day >= 10) ? '$day' : '0$day';
    String y = (year >= 10) ? '$year' : '0$year';

    return '$m/$d/$y';
  }

  static Date fromString(String str) {
    List<String> dateValues = str.split("/");
    return Date(int.parse(dateValues[0]), int.parse(dateValues[1]),
        int.parse(dateValues[2]));
  }

  static Date fromDateTime(DateTime date) {
    int y = int.parse(date.year.toString().substring(2));
    int m = date.month;
    int d = date.day;
    return Date(m, d, y);
  }

  DateTime toDateTime() {
    int y = int.parse("${DateTime.now().year.toString().substring(0, 2)}$year");
    return new DateTime(y, month, day);
  }
}

class Assignment {
  String name;
  Date dueDate;
  Subject subject;
  int priority;
  bool isCreated;
  String timeOfCreation;

  Assignment(String name, Date dueDate, Subject subject, int priority,
      bool isCreated) {
    this.name = name;
    this.dueDate = dueDate;
    this.subject = subject;
    this.priority = priority;
    this.isCreated = isCreated;
    timeOfCreation = DateTime.now().toString();
      }


  static Assignment fromString(String data) {
    List<String> split = data.split(" ");
    if (split.length == 6) {
      Assignment result = new Assignment(reformat(split[0]), Date.fromString(split[1]), subjectFromString(split[2]), int.parse(split[3]), true);
      result.timeOfCreation = reformat(split[5]);
      return result;
    }
    return null;
  }

  String formatName() {
    return name.replaceAll(" ", "_");
  }
  static String reformat(String name) {
    return name.replaceAll("_", " ");
  }
  String formatDate() {
    return timeOfCreation.replaceAll(" ", "_");
  }

  String subjectToString() {
    // MATH, SIENCE, ENGLISH, HISTORY, LANGUAGE, OTHER
    switch (subject) {
      case Subject.MATH:
        return "Math";
      case Subject.SCIENCE:
        return "Science";
      case Subject.ENGLISH:
        return "English";
      case Subject.HISTORY:
        return "History";
      case Subject.LANGUAGE:
      return "Language";
      case Subject.OTHER:
      return "Other";
    }
    return "Other";
  }

  static Subject subjectFromString(String sub) {
    if (sub == "Math") return Subject.MATH;
    else if (sub == "Science") return Subject.SCIENCE;
    else if (sub == "English") return Subject.ENGLISH;
    else if (sub == "History") return Subject.HISTORY;
    else if (sub == "Language") return Subject.LANGUAGE;
    else if (sub == "Other") return Subject.OTHER;
  }

  bool isOverDue() {
    DateTime currentDate = DateTime.now();
    DateTime dueDate = this.dueDate.toDateTime();

    if (currentDate.isAfter(dueDate)) return true;
    return false;
  }
}

class Sort {

  static int compairSubject(Subject sub1, Subject sub2) {
    List<Subject> base = [Subject.MATH, Subject.SCIENCE, Subject.ENGLISH, Subject.HISTORY, Subject.LANGUAGE, Subject.OTHER];
    int index1 = base.indexOf(sub1);
    int index2 = base.indexOf(sub2);
    return index1 - index2;
  }

  static List<Assignment> sortAlphabetically(List<Assignment> list) {
    if (list.length > 0) {
      for (int j = 0; j < list.length; j++) {
        for (int k = j; k < list.length; k++) {
          if (list[j].name.compareTo(list[k].name) > 0) {
            Assignment buffer = list[j];
            list[j] = list[k];
            list[k] = buffer;
          }
        }
      }
      return list;
    } else
      return list;
  }

  static List<Assignment> sortNewest(List<Assignment> list) {
    if (list.length > 0) {
      for (int j = 0; j < list.length; j++) {
        for (int k = j; k < list.length; k++) {
          DateTime tocA = DateTime.parse(list[j].timeOfCreation);
          DateTime tocB = DateTime.parse(list[k].timeOfCreation);
          if (tocA.isBefore(tocB)) {
            Assignment buffer = list[j];
            list[j] = list[k];
            list[k] = buffer;
          }
        }
      }
      return list;
    } else
      return list;
  }

  static List<Assignment> sortOldest(List<Assignment> list) {
    if (list.length > 0) {
      for (int j = 0; j < list.length; j++) {
        for (int k = j; k < list.length; k++) {
          DateTime tocA = DateTime.parse(list[j].timeOfCreation);
          DateTime tocB = DateTime.parse(list[k].timeOfCreation);
          if (tocB.isBefore(tocA)) {
            Assignment buffer = list[j];
            list[j] = list[k];
            list[k] = buffer;
          }
        }
      }
      return list;
    } else
      return list;
  }

  static List<Assignment> sortDueDate(List<Assignment> list) {
    if (list.length > 0) {
      for (int j = 0; j < list.length; j++) {
        for (int k = j; k < list.length; k++) {
          DateTime dateA = list[j].dueDate.toDateTime();
          DateTime dateB = list[k].dueDate.toDateTime();
          if (dateB.isBefore(dateA)) {
            Assignment buffer = list[j];
            list[j] = list[k];
            list[k] = buffer;
          }
        }
      }
      return list;
    } else
      return list;
  }

  static List<Assignment> sortPriority(List<Assignment> list) {
    if (list.length > 0) {
      for (int j = 0; j < list.length; j++) {
        for (int k = j; k < list.length; k++) {
          int priorityA = list[j].priority;
          int priorityB = list[k].priority;
          if (priorityA < priorityB) {
            Assignment buffer = list[j];
            list[j] = list[k];
            list[k] = buffer;
          }
        }
      }
      return list;
    } else
      return list;
  }

  static List<Assignment> sortSubject(List<Assignment> list) {
    if (list.length > 0) {
      for (int j = 0; j < list.length; j++) {
        for (int k = j; k < list.length; k++) {
          Subject subA = list[j].subject;
          Subject subB = list[k].subject;
          if (compairSubject(subA, subB) > 0) {
            Assignment buffer = list[j];
            list[j] = list[k];
            list[k] = buffer;
          }
        }
      }
      return list;
    } else
      return list;
  }
}
