

class userModel{
  int? id;
  String? petName;
  String? petBreed;
  String? profile;
  int? balanace;

  userModel({
    this.id,
    this.petName,
    this.petBreed,
    this.profile,
    this.balanace
    });

    factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      id:json["id"],
      petName: json['pet_name']??'Pet Name',
      petBreed: json['pet_breed'],
      profile: json['profile'],
      balanace: json["balance"]
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      'pet_name': petName,
      'pet_breed': petBreed,
      'profile': profile,
      "balance":balanace
      
    };
  }



}