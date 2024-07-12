import 'dart:convert';

ModelPegawai modelPegawaiFromJson(String str) => ModelPegawai.fromJson(json.decode(str));

String modelPegawaiToJson(ModelPegawai data) => json.encode(data.toJson());

class ModelPegawai {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelPegawai({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelPegawai.fromJson(Map<String, dynamic> json) => ModelPegawai(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String firstname;
  String lastname;
  String phonenumber;
  String email;
  String jeniskelamin;
  String status;

  Datum({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phonenumber,
    required this.email,
    required this.jeniskelamin,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    phonenumber: json["phonenumber"],
    email: json["email"],
    jeniskelamin: json["jeniskelamin"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "phonenumber": phonenumber,
    "email": email,
    "jeniskelamin": jeniskelamin,
    "status": status,
  };
}
