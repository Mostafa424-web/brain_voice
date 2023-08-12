class DataGloves {
  DataGloves({
    required this.id,
    required this.letter,
  });

  late final String id;
  late final String letter;

  DataGloves.fromJson(Map<String, dynamic> json){
    id = json['id'];
    letter = json['letter'];
  }
}