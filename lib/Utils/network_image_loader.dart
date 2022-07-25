import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';

class NetworkImageLoader {
  String url;


  NetworkImageLoader(this.url);


  var client = http.Client();
  Future<Uint8List> load() async {
    final Uri resolved = Uri.base.resolve(this.url);

    final dynamic response = await client.get(resolved);
    print('4444444');
    if (response.statusCode != 200)
      throw new Exception('HTTP request failed, statusCode: ${response.statusCode}, $resolved');
print('55555');
    final Uint8List bytes = response.bodyBytes;
    if (bytes.lengthInBytes == 0)
      throw new Exception('NetworkImage is an empty file: $resolved');

    return bytes;
  }
}