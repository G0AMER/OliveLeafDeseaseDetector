import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  static MongoDBService get instance => _instance;

  late Db _db;

  MongoDBService._internal();

  Future<void> connect() async {
    _db = await Db.create(
        'mongodb+srv://marwachaarie:marwa2001chaari@cluster0.i8ipsch.mongodb.net/?retryWrites=true&w=majority' /*'mongodb+srv://marwachaarie:marwa2001chaari@cluster0.i8ipsch.mongodb.net/?retryWrites=true&w=majority'*/);

    await _db.open();
  }

  Future<void> close() async {
    await _db.close();
  }

  // Implement your database operations here

  Future<void> createUser(String name, String email, String password) async {
    final collection = _db.collection('users');
    await collection.save({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final collection = _db.collection('users');
    final user = await collection.findOne({'email': email});
    return user;
  }
}
