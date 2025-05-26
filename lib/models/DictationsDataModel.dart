class DictationsDataModel {
  DictationsDataModel({
    this.status,
    this.data,
    this.message,
  });

  DictationsDataModel.fromJson(dynamic json) {
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
    this.id,
    this.dictationsdataUrl,
    this.filename,
    this.fileUploadedDateTime,
    this.status,
    this.createdAt,
    this.deletedAt,
    this.audioText,
    this.file_status,
    this.userid,
    this.fileSize,
    this.fileDuration,
    this.isBookmark,
    this.updatedAt,
    this.isDeleted,
    this.is_local,
    this.is_ftp,
    this.isSelected
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    is_ftp= json['is_ftp'];
    is_local= json['is_local'];
    dictationsdataUrl = json['dictationsdata_url'];
    filename = json['filename'];
    fileUploadedDateTime = json['file_uploaded_date_time'];
    status = json['status'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    audioText =json['audio_text'];
    userid = json['userid'];
    fileSize = json['file_size'];
    fileDuration = json['file_duration'];
    isBookmark = json['is_bookmark'];
    updatedAt = json['updated_at'];
    file_status = json['file_status'];
    isDeleted = json['is_deleted'];
    isSelected = false;
  }
  int? id;
  String? dictationsdataUrl;
  String? filename;
  String? fileUploadedDateTime;
  int? status;
  int? file_status;
  String? createdAt;
  dynamic deletedAt;
  String? audioText;
  int? userid;
  String? fileSize;
  String? fileDuration;
  bool? isBookmark;
  String? updatedAt;
  bool? isDeleted;
  bool? isSelected;
  bool? is_ftp;
  bool? is_local;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['dictationsdata_url'] = dictationsdataUrl;
    map['filename'] = filename;
    map['file_uploaded_date_time'] = fileUploadedDateTime;
    map['status'] = status;
     map['is_ftp'] = is_ftp;
    map['created_at'] = createdAt;
    map['deleted_at'] = deletedAt;
    map['audio_text'] = audioText;
    map['userid'] = userid;
    map['file_size'] = fileSize;
    map['file_duration'] = fileDuration;
    map['is_bookmark'] = isBookmark;
    map['updated_at'] = updatedAt;
    map['is_deleted'] = isDeleted;
     map['is_local'] = is_local;
    map['file_status'] = file_status;
    return map;
  }
}
