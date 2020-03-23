import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';

Database db;

class WalgotechDB {
  static const usersTable = 'users';
  static const id = 'id';
  static const userName = 'userName';
  static const password = 'password';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const contact = 'phoneNumber';
}

class SmsManager {
  Database _database;
  static const databaseName = 'SMS.db';
  static const number = 'number';
  static const formOne = 'formOne';
  static const id = 'id';
  static const message = 'message';
  static const sender = 'sender';
  static const date = 'date';
  static const recipent = 'recipent';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), SmsManager.databaseName), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE formOne ("
            "id INTEGER PRIMARYKEY,"
            "message TEXT,"
            "sender TEXT,"
            "recipent TEXT,"
            "date TEXT"
            ")");
      });
    }
  }

  Future<int> insertSMS(SMS sms) async {
    await openDB();
    return await _database.insert(SmsManager.formOne, sms.toMap());
  }

  Future<List<SMS>> getSMSList() async {
    await openDB();
    final List<Map<String, dynamic>> sms = await _database.query(SmsManager.formOne);
    return List.generate(sms.length, (i) {
      return SMS(
        id: sms[i][SmsManager.id],
        message: sms[i][SmsManager.message],
        sender: sms[i][SmsManager.sender],
        dateTime: sms[i][SmsManager.date],
        recipent: sms[i][SmsManager.recipent],
      );
    });
  }

  Future<int> updateSMS(SMS sms) async {
    await openDB();
    return await _database.update(
      SmsManager.formOne,
      sms.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteSMS(int id) async {
    await openDB();
    await _database.delete(
      SmsManager.formOne,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    await openDB();
    await _database.delete(formOne);
  }
}

class ContactsManager {
  Database _database;
  static const databaseName = 'SMS.db';
  static const id = 'id';
  static const number = 'number';
  static const tableName = 'formOne';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), ContactsManager.databaseName),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE formOne (id INTEGER PRIMARYKEY autoIncrement, number TEXT, )');
      });
    }
  }

  Future<int> addContact(Contacts contact) async {
    await openDB();
    return await _database.insert(ContactsManager.databaseName, contact.toMap());
  }
}
