import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:simple_budget/utils/net/helper/netutil_exception.dart';
import 'package:simple_budget/utils/net/netutil_global.dart';
import 'package:simple_budget/utils/net/helper/netutil_type.dart';

class NetUtils {
  static String? bearerToken;

  /// refreshJWT
  /// Refresh current JWT token with the one stored on the Encrypted Box under
  /// User Shared Preferences.
  static void setJWT({required String bearerToken}) {
    bearerToken = bearerToken;
  }

  /// clearJWT
  /// Clear current JWT Token and set it as NULL
  static void clearJWT() {
    bearerToken = null;
  }

  static Map<String, String> _header({required NetType type, required bool? requiredJWT}) {
    Map<String, String> header = {};
    
    // default the header into no bearer token
    header = {
      'Content-Type': 'application/json',
    };

    if (requiredJWT ?? true) {
      if (bearerToken == null) {
        throw NetException(
          code: 403,
          type: type,
          message: "No bearer token",
        );
      }
    }

    // check if bearer token is null and whether required jwt or not?
    if (bearerToken != null && (requiredJWT ?? true)) {
      header = {
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        'Content-Type': 'application/json',
      };
    }

    return header;
  }

  /// get
  /// This is to sending GET request to the API Server
  /// Parameter needed for this are:
  /// - required : url         : String
  /// - optional : params      : Map<String, dynamic>
  static Future get({
    required String url,
    Map<String, dynamic>? params,
    bool? requiredJWT,
  }) async {
    // generate the additional params
    var uri = Uri.parse(url);
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    // bearer token is not empty, we can perform call to the API
    final response = await http.get(
      uri,
      headers: _header(type: NetType.get, requiredJWT: requiredJWT),
    ).timeout(
      const Duration(seconds: NetutilGlobal.apiTimeOut),
      onTimeout: () {
        throw NetException(
          code: 504,
          type: NetType.get,
          message: 'Gateway Timeout for $url'
        );
      },
    );

    // check the response we got from http
    if (response.statusCode == 200) {
      return response.body;
    }

    // status code is not 200, means we got error
    throw NetException(
      code: response.statusCode,
      type: NetType.get,
      message: response.reasonPhrase ?? '',
      body: response.body,
    );
  }

  /// post
  /// This is to sending POST request to the API Server
  /// Parameter needed for this are:
  /// - required : url         : String
  /// - optional : params      : Map<String, dynamic>
  /// - required : body        : Map<String, dynamic>
  /// - optional : requiredJWT : bool
  static Future post({
    required String url,
    Map<String, dynamic>? params,
    required Map<String, dynamic> body,
    bool? requiredJWT
  }) async {
    // generate the additional params
    var uri = Uri.parse(url);
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    // bearer token is not empty, we can perform call to the API
    final response = await http.post(
      uri,
      headers: _header(type: NetType.post, requiredJWT: requiredJWT),
      body: jsonEncode(body)
    ).timeout(
      const Duration(seconds: NetutilGlobal.apiTimeOut),
      onTimeout: () {
        throw NetException(
          code: 504,
          type: NetType.post,
          message: 'Gateway Timeout for $url'
        );
      },
    );

    // check the response we got from http
    if (response.statusCode == 200) {
      return response.body;
    }

    // status code is not 200, means we got error
    throw NetException(
      code: response.statusCode,
      type: NetType.post,
      message: response.reasonPhrase ?? '',
      body: response.body,
    );
  }

  /// delete
  /// This is to sending DELETE request to the API Server
  /// Parameter needed for this are:
  /// - required : url         : String
  /// - optional : params      : Map<String, dynamic>
  static Future delete({
    required String url,
    Map<String, dynamic>? params,
    bool? requiredJWT,
  }) async {
    // generate the additional params
    var uri = Uri.parse(url);
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    // bearer token is not empty, we can perform call to the API
    final response = await http.delete(
      uri,
      headers: _header(type: NetType.delete, requiredJWT: requiredJWT),
    ).timeout(
      const Duration(seconds: NetutilGlobal.apiTimeOut),
      onTimeout: () {
        throw NetException(
          code: 504,
          type: NetType.delete,
          message: 'Gateway Timeout for $url'
        );
      },
    );

    // check the response we got from http
    if (response.statusCode == 200) {
      return response.body;
    }

    // status code is not 200, means we got error
    throw NetException(
      code: response.statusCode,
      type: NetType.delete,
      message: response.reasonPhrase ?? '',
      body: response.body,
    );
  }

  /// patch
  /// This is to sending PATCH request to the API Server
  /// Parameter needed for this are:
  /// - required : url         : String
  /// - optional : params      : Map<String, dynamic>
  /// - required : body        : Map<String, dynamic>
  static Future patch({
    required String url,
    Map<String, dynamic>? params,
    required Map<String, dynamic> body,
    bool? requiredJWT,
  }) async {
    // generate the additional params
    var uri = Uri.parse(url);
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    // bearer token is not empty, we can perform call to the API
    final response = await http.patch(
      uri,
      headers: _header(
        type: NetType.patch,
        requiredJWT: requiredJWT
      ),
      body: jsonEncode(body)
    ).timeout(
      const Duration(seconds: NetutilGlobal.apiTimeOut),
      onTimeout: () {
        throw NetException(
          code: 504,
          type: NetType.patch,
          message: 'Gateway Timeout for $url'
        );
      },
    );

    // check the response we got from http
    if (response.statusCode == 200) {
      return response.body;
    }

    // status code is not 200, means we got error
    throw NetException(
      code: response.statusCode,
      type: NetType.patch,
      message: response.reasonPhrase ?? '',
      body: response.body,
    );
  }

  /// put
  /// This is to sending PUT request to the API Server
  /// Parameter needed for this are:
  /// - required : url         : String
  /// - optional : params      : Map<String, dynamic>
  /// - required : body        : Map<String, dynamic>
  static Future put({
    required String url,
    Map<String, dynamic>? params,
    required Map<String, dynamic> body,
    bool? requiredJWT,
  }) async {
    // generate the additional params
    var uri = Uri.parse(url);
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    // bearer token is not empty, we can perform call to the API
    final response = await http.put(
      uri,
      headers: _header(type: NetType.put, requiredJWT: requiredJWT),
      body: jsonEncode(body)
    ).timeout(
      const Duration(seconds: NetutilGlobal.apiTimeOut),
      onTimeout: () {
        throw NetException(
          code: 504,
          type: NetType.put,
          message: 'Gateway Timeout for $url'
        );
      },
    );

    // check the response we got from http
    if (response.statusCode == 200) {
      return response.body;
    }

    // status code is not 200, means we got error
    throw NetException(
      code: response.statusCode,
      type: NetType.put,
      message: response.reasonPhrase ?? '',
      body: response.body,
    );
  }
}