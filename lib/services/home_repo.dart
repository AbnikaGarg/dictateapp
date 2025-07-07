import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../utils/app_urls.dart';
import 'shared_pref.dart';

class HomepageService {
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  Future<Response> getDictations(type) async {
    var userid = PreferenceUtils.getString("userid");
    var ur = type == 0
        ?Uri.parse(AppUrls.BASE_URL +
            AppUrls.get_all_dictation +
            "?user_id=$userid&dictation_type=2")
        : Uri.parse(AppUrls.BASE_URL +
            AppUrls.get_all_dictation +
            "?user_id=$userid&dictation_type=$type");
    var token = PreferenceUtils.getUserToken();
    try {
      final response = await http.get(ur, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> getFolders() async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.get_all_folders);
    var token = PreferenceUtils.getUserToken();
    try {
      final response = await http.get(ur, headers: {
        "Content-Type": "application/json; charset=utf-8",
        'Authorization': 'Bearer $token',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> getSeting() async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.setting);
    var token = PreferenceUtils.getUserToken();
    try {
      final response = await http.get(ur, headers: {
        "Content-Type": "application/json; charset=utf-8",
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImV4cCI6MTc3MjI5OTc1NX0.ffFdIT-SWUCxrFJ39K0QNXyLaT7h7_v9BJv0PGsZL7w',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> createFolder(name, id) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.create_folder);
    var token = PreferenceUtils.getUserToken();
    try {
      final response = await http.post(ur,
          body: json.encode({"foldername": name, "is_deleted": false}),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            'Authorization': 'Bearer $token',
          });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> createDictation(
      name, date, url, size, duration, type) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.create_dic);
    var token = PreferenceUtils.getUserToken();
    var userid = PreferenceUtils.getString("userid");
    try {
      final response = await http.post(ur,
          body: json.encode({
            "userid": userid,
            "file_uploaded_date_time": date,
            "dictationdetails": [
              {
                "dictationsdata_url": url,
                "filename": name,
                "file_size": size,
                "file_duration": duration,
                "status": 1,
                "is_local": true,
                "is_ftp": true
              }
            ]
          }),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            'Authorization': 'Bearer $token',
          });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> createDictationList(newData) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.create_dic);
    var token = PreferenceUtils.getUserToken();
    var userid = PreferenceUtils.getString("userid");
    try {
      final response = await http.post(ur,
          body: json.encode({
            "userid": userid,
            "file_uploaded_date_time": "2025-03-18T00:00:00",
            "dictationdetails": newData
          }),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            'Authorization': 'Bearer $token',
          });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> DeleteDictationList(id, type) async {
    var ur =
        Uri.parse(AppUrls.BASE_URL + AppUrls.deleteDic + "?dictation_type=3");
    var token = PreferenceUtils.getUserToken();
    var userid = PreferenceUtils.getString("userid");
    try {
      final response = await http.delete(ur, body: jsonEncode(id), headers: {
        "Content-Type": "application/json; charset=utf-8",
        'Authorization': 'Bearer $token',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> uploadServcer(id) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.local_to_server);
    var token = PreferenceUtils.getUserToken();
    var userid = PreferenceUtils.getString("userid");
    try {
      final response = await http.post(ur, body: jsonEncode(id), headers: {
        "Content-Type": "application/json; charset=utf-8",
        'Authorization': 'Bearer $token',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> getUser() async {
    var userid = PreferenceUtils.getString("userid");
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.getUser + "?user_id=$userid");
    var token = PreferenceUtils.getUserToken();

    try {
      final response = await http.get(ur, headers: {
        "Content-Type": "application/json; charset=utf-8",
        'Authorization': 'Bearer $token',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> updateSetting(
      microphone_sensitivity, date_format, auto_file_deletion) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.updatesetting);
    var token = PreferenceUtils.getUserToken();
    var userid = PreferenceUtils.getString("userid");
    try {
      final response = await http.patch(ur,
          body: json.encode({
            "userid": userid,
            "audio_quality": "24kz",
            "microphone_sensitivity": microphone_sensitivity,
            "date_format": date_format,
            "auto_file_deletion": auto_file_deletion,
            "auto_pause": true
          }),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            'Authorization': 'Bearer $token',
          });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
}
