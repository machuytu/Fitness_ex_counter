var listWeight = new List<int>.generate(300, (i) => i + 1);
var listHeight = new List<int>.generate(250, (i) => i + 1);
var listAge = new List<int>.generate(300, (i) => i + 1);
String pickerWeight = '''
[
  $listWeight,
  [
    "Kg"     
  ]
]
    ''';

String pickerHeight = '''
[
  $listHeight,
  [
    "Cm"
  ]
]
    ''';

String pickerModeFitness = '''
[
  [
    "Get Fit (easy)",
    "Workout (medium)",
    "Gain Muscle (hard)"
  ]
]
    ''';
