import 'package:handcricket/config.dart';
import 'package:http/http.dart';

/// isSuccess returns true if the request was successfully received, understood,
/// and accepted. 2xx status codes represent this.
bool isSuccess(Response response) {
  return response.statusCode >= 200 && response.statusCode < 300;
}

/// url generates a URL which points to our App Engine game servers. It also
/// supplies the API key.
String url(String endpoint) {
  assert(endpoint[0] == '/'); // the endpoint must start with a forward slash
  endpoint = "/_ah/api/handcricket/v1$endpoint";
  return "https://$hostName$endpoint?key=$apiKey";
}
