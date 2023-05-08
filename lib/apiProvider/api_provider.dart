import 'package:http/http.dart' as http;

class ApiProvider {
  static final ApiProvider _singletonApiProvider = ApiProvider._internal();

  factory ApiProvider() {
    return _singletonApiProvider;
  }

  ApiProvider._internal();

  Future getMethod(String apiUrl) async {
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');

    return response.body;
  }

  Future getApiMethod(String apiUrl) async {
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    print('Response status : ${response.statusCode}');

    return response.body;
  }

  Future postMethod(String apiUrl) async {
    var url = Uri.parse(apiUrl);
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');

    return response.body;
  }

  Future putMethod(String apiUrl) async {
    var url = Uri.parse(apiUrl);
    var response = await http.put(url);
    print('Response status: ${response.statusCode}');

    return response.body;
  }
}
