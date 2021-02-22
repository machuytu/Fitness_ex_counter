var listWeight = new List<int>.generate(300, (i) => i + 1);
var listHeight = new List<int>.generate(300, (i) => i + 1);
String pickerWeight = '''
[
    $listWeight,
    [
        "Kg",
        "Jb"
    ]
]
    ''';

String pickerHeight = '''
[
    $listHeight,
    [
        "Cm",
        "Ft"
    ]
]
    ''';
