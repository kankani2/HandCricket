import 'dart:convert';

import 'package:handcricket/config.dart';
import 'package:handcricket/utils/firebase_auth.dart';
import 'package:http/http.dart';

enum HttpMethod { DELETE, GET, POST, PUT }

/// isSuccess returns true if the request was successfully received, understood,
/// and accepted. 2xx status codes represent this.
bool isSuccess(Response response) {
  return response.statusCode >= 200 && response.statusCode < 300;
}

/// url generates a URL which points to our App Engine game servers. Based on
/// dev mode it makes the url point to local server or app engine.
String url(String endpoint) {
  assert(endpoint[0] == '/'); // the endpoint must start with a forward slash
  endpoint = "/_ah/api/handcricket/v1$endpoint";
  if (devMode) {
    return "http://localhost:8080$endpoint";
  }
  return "https://$hostName$endpoint";
}

/// Generates header for every http request based on the following documentation.
/// https://cloud.google.com/endpoints/docs/openapi/authenticating-users-firebase#making_an_authenicated_call_to_an_endpoints_api
Future<Map<String, String>> header() async {
  if (devMode) {
    return null;
  }

  var token = await getFirebaseAuthToken();
  return {"Authorization": "Bearer $token"};
}

/// request is just a wrapper that handles generating the header, url and
/// encoding the body.
Future<Response> request(HttpMethod method, String endpoint,
    {Map<String, dynamic> body}) async {
  var _url = url(endpoint);
  var _header = await header();
  var _body = json.encode(body);

  switch (method) {
    case HttpMethod.DELETE:
      return delete(_url, headers: _header);
    case HttpMethod.GET:
      return get(_url, headers: _header);
    case HttpMethod.POST:
      if (body == null) return post(_url, headers: _header);
      return post(_url, body: _body, headers: _header);
    case HttpMethod.PUT:
      if (body == null) return put(_url, headers: _header);
      return put(_url, body: _body, headers: _header);
  }

  return null;
}
