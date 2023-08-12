class DataModel {
  final String id , animateVideo;

  DataModel({
    required this.id,
    required this.animateVideo,
  });
 factory  DataModel.fromJson(Map<String , dynamic> json) {
   return DataModel(
       id : json["id"],
       animateVideo : json["animate_assets"]
   );
  }

}

class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      age: json['age'],
    );
  }
}