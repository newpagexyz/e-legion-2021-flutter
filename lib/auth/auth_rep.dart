import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientRepository = Provider((ref) {
  final _client = http.Client();

  ref.onDispose(() {
    _client.close();
  });

  return _client;
});
