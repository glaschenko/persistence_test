import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MyPersistentStorage{
  void persist(String string, int counter);
  Future<String> loadString();
  Future<int> loadCounter();
}

class DummyStorage extends MyPersistentStorage{

  @override
  void persist(String string, int counter) async {
  }

  @override
  Future<int> loadCounter() async {
    return Future.value(777);
  }

  @override
  Future<String> loadString() async {
    return Future.value("Dummy");
  }
}

class FileStorage extends MyPersistentStorage{

  @override
  void persist(String string, int counter) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var file = File(directory.path + 'sample.json');
    if(file.existsSync()) file.deleteSync();
    file.createSync();
    Map data = {
      "string": string,
      "counter": counter
    };
    var jsonContent = json.encode(data);
    file.writeAsString(jsonContent,  flush: true);
  }

  @override
  Future<int> loadCounter() async {
    return _loadValue<int>("counter");
  }

  Future<T> _loadValue<T>(String key) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var file = File(directory.path + 'sample.json');
    if(!file.existsSync()) return Future.value(null);

    final currentDataString = await file.readAsString();
    try {
      Map res = json.decode(currentDataString) as Map;
      return Future.value(res[key]);
    } catch (e) {
      print('Resetting file, incorrect format');
      file.writeAsString('{}');
      return Future.value(null);
    }
  }

  @override
  Future<String> loadString() async {
    return _loadValue<String>("string");
  }
}

class SharedPreferenceStorage extends MyPersistentStorage{

  @override
  void persist(String string, int counter) async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("string", string);
    sp.setInt("counter", counter);
  }

  @override
  Future<int> loadCounter() async{
    var sp = await SharedPreferences.getInstance();
    return Future.value(sp.getInt("counter"));
  }

  @override
  Future<String> loadString() async{
    var sp = await SharedPreferences.getInstance();
    return Future.value(sp.getString("string"));
  }
}
