class FolderModel {
  FolderModel({
      this.status, 
      this.data, 
      this.message,});

  FolderModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }
  bool? status;
  List<Data>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
      this.foldername, 
      this.updatedAt, 
      this.userid, 
      this.isDeleted, 
      this.createdAt, 
      this.id, 
      this.deletedAt,});

  Data.fromJson(dynamic json) {
    foldername = json['foldername'];
    updatedAt = json['updated_at'];
    userid = json['userid'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    id = json['id'];
    deletedAt = json['deleted_at'];
  }
  String? foldername;
  String? updatedAt;
  int? userid;
  bool? isDeleted;
  String? createdAt;
  int? id;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['foldername'] = foldername;
    map['updated_at'] = updatedAt;
    map['userid'] = userid;
    map['is_deleted'] = isDeleted;
    map['created_at'] = createdAt;
    map['id'] = id;
    map['deleted_at'] = deletedAt;
    return map;
  }

}