import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:handcricket/config.dart';

enum HttpMethod {
  DELETE,
  GET,
  POST,
  PUT,
}

/// isSuccess returns true if the request was successfully received, understood,
/// and accepted. 2xx status codes represent this.
bool isSuccess(HttpClientResponse response) {
  return response.statusCode >= 200 && response.statusCode < 300;
}

/// readResponse has been taken from https://stackoverflow.com/a/27809811/6935187.
Future<Map<String, dynamic>> readResponse(HttpClientResponse response) {
  final completer = Completer<Map<String, dynamic>>();
  final contents = StringBuffer();
  response.transform(utf8.decoder).listen((data) {
    contents.write(data);
  }, onDone: () => completer.complete(json.decode(contents.toString())));
  return completer.future;
}

/// url generates a URL which points to our App Engine game servers. It also
/// supplies the API key.
String url(String endpoint) {
  assert(endpoint[0] == '/'); // the endpoint must start with a forward slash
  endpoint = "/_ah/api/handcricket/v1$endpoint";
  return "https://$hostName$endpoint?key=$apiKey";
}

/// request makes a HTTP request to the endpoint specified with the correct
/// method type and body.
Future<HttpClientResponse> request(
    HttpMethod method, String endpoint, Map<String, dynamic> body) {
  HttpClient client = new HttpClient();
  Uri uri = Uri.parse(url(endpoint));

  Future<HttpClientRequest> futureReq;
  switch (method) {
    case HttpMethod.DELETE:
      futureReq = client.deleteUrl(uri);
      break;
    case HttpMethod.GET:
      futureReq = client.getUrl(uri);
      break;
    case HttpMethod.POST:
      futureReq = client.postUrl(uri);
      break;
    case HttpMethod.PUT:
      futureReq = client.putUrl(uri);
      break;
  }

  return futureReq.then((req) {
    if (body.isNotEmpty) {
      req.write(json.encode(body));
    }
    return req.close();
  });
}
