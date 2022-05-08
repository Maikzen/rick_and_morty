import 'dart:convert';

Filter filterFromJson(String str) => Filter.fromJson(json.decode(str));

String filterToJson(Filter data) => json.encode(data.toJson());

class Filter {
  Filter({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.page,
  });

  String? name;
  String? status;
  String? species;
  String? type;
  String? gender;
  int? page;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        name: json["name"],
        status: json["status"],
        species: json["species"],
        type: json["type"],
        gender: json["gender"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "status": status,
        "species": species,
        "type": type,
        "gender": gender,
        "page": page,
      };
}
