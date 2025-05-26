import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../components/app_urls.dart';
import '../utils/app_urls.dart';

class AuthRepo {
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  Future<Response> apiLoginService(
      String? username, String? password, devicetoekn) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.login);
    try {
      //   var request = http.MultipartRequest('POST', ur);
      //   request.fields['username'] = username!;
      //   request.fields['password'] = password!;

      /// var response = await request.send();
      final response = await http.post(
        ur,
        body: json.encode({
          "username": username,
          "password": password,
          "deviceid": devicetoekn
        }),   headers: {
            "Content-Type": "application/json; charset=utf-8",
            
          }
      );
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
    // catch(e){
    //     return Response(statusCode: 1, statusText: noInternetMessage);
    // }
  }

  Future<Response> apiSentOtp(String? username) async {
    var ur = Uri.parse(
        AppUrls.BASE_URL + AppUrls.forgetPassword + "?username=$username");
    try {
      //   var request = http.MultipartRequest('POST', ur);
      //   request.fields['username'] = username!;
      //   request.fields['password'] = password!;

      /// var response = await request.send();
      final response = await http.patch(
        ur,
      );
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
    // catch(e){
    //     return Response(statusCode: 1, statusText: noInternetMessage);
    // }
  }

  Future<Response> apiVerifyOtp(otp, password, username) async {
    var ur = Uri.parse(AppUrls.BASE_URL +
        AppUrls.otpVerify +
        "?otp=$otp&newpassword=$password&username=$username");
    try {
      //   var request = http.MultipartRequest('POST', ur);
      //   request.fields['username'] = username!;
      //   request.fields['password'] = password!;

      /// var response = await request.send();
      final response = await http.post(
        ur,
      );
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
    // catch(e){
    //     return Response(statusCode: 1, statusText: noInternetMessage);
    // }
  }
}
