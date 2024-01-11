class Data {
  final String name;
  final DateTime date;
  final String studentClass;
  final String studentGrade;

  Data(this.name, this.date, this.studentClass, this.studentGrade);
}

final List<String> names = [
  'محمود',
  'وليد السلق',
  'نور الدين طوطو',
  'محمد وليد ميسي'
];

class dataClass {
  static List admins = [];
  static List students = [];
  static List grades = [];
  static List gradesName = [];
  static String urlHost = 'http://127.0.0.1:8000/';
}
