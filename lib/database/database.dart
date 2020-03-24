import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';

Database db;


class SmsManager {
  Database _database;
  static const databaseName = 'messaging.db';
  static const number = 'number';
  static const tableName = 'messages';
  static const id = 'id';
  static const message = 'message';
  static const sender = 'sender';
  static const date = 'date';
  static const recipent = 'recipent';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), SmsManager.databaseName), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE messages ("
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
    return await _database.insert(SmsManager.tableName, sms.toMap());
  }

  Future<List<SMS>> getSMSList() async {
    await openDB();
    final List<Map<String, dynamic>> sms = await _database.query(SmsManager.tableName);
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
      SmsManager.tableName,
      sms.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteSMS(int id) async {
    await openDB();
    await _database.delete(
      SmsManager.tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    await openDB();
    await _database.delete(tableName);
  }
}

class ContactsManager {
  Database _database;
  static const databaseName = 'messaging.db';
  static const id = 'id';
  static const tableName = 'contacts';
  static const motherNumber = 'motherNumber';
  static const fatherNumber = 'fatherNumber';
  static const guardianNumber = 'guardianNumber';
  static const form = 'form';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), ContactsManager.databaseName),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE contacts ("
            "id INTEGER PRIMARYKEY,"
            "fatherNumber TEXT,"
            "motherNumber TEXT,"
            "guardianNumber TEXT,"
            "form TEXT"
            ")");
      });
    }
  }

  Future<int> addContacts(Contacts contact) async {
    await openDB();
    return await _database.insert('contacts', contact.toMap());
  }

  Future<List<Contacts>> getAllContacts() async {
    await openDB();
    final List<Map<String, dynamic>> contacts = await _database.query(ContactsManager.tableName);
    return List.generate(contacts.length, (i) {
      return Contacts(
          fatherNumber: contacts[i][ContactsManager.fatherNumber],
          motherNumber: contacts[i][ContactsManager.motherNumber],
          guardianNumber: contacts[i][ContactsManager.guardianNumber],
          form: contacts[i][ContactsManager.form]);
    });
  }

  Future<List<Contacts>> getFormOne() async {
    await openDB();
    final List<Map<String, dynamic>> formOnecontacts =
        await _database.query(ContactsManager.tableName, where: 'form = ("Form1")');
    return List.generate(formOnecontacts.length, (i) {
      return Contacts(
        fatherNumber: formOnecontacts[i][ContactsManager.fatherNumber],
        form: formOnecontacts[i][ContactsManager.form],
        guardianNumber: formOnecontacts[i][ContactsManager.guardianNumber],
        motherNumber: formOnecontacts[i][ContactsManager.motherNumber],
      );
    });
  }
   Future<List<Contacts>> getFormTwo() async {
    await openDB();
    final List<Map<String, dynamic>> formTwocontacts =
        await _database.query(ContactsManager.tableName, where: 'form = ("Form2")');
    return List.generate(formTwocontacts.length, (i) {
      return Contacts(
        fatherNumber: formTwocontacts[i][ContactsManager.fatherNumber],
        form: formTwocontacts[i][ContactsManager.form],
        guardianNumber: formTwocontacts[i][ContactsManager.guardianNumber],
        motherNumber: formTwocontacts[i][ContactsManager.motherNumber],
      );
    });
  }
  Future<List<Contacts>> getFormThree() async {
    await openDB();
    final List<Map<String, dynamic>> formThreecontacts =
        await _database.query(ContactsManager.tableName, where: 'form = ("Form3")');
    return List.generate(formThreecontacts.length, (i) {
      return Contacts(
        fatherNumber: formThreecontacts[i][ContactsManager.fatherNumber],
        form: formThreecontacts[i][ContactsManager.form],
        guardianNumber: formThreecontacts[i][ContactsManager.guardianNumber],
        motherNumber: formThreecontacts[i][ContactsManager.motherNumber],
      );
    });
  }
  Future<List<Contacts>> getFormFour() async {
    await openDB();
    final List<Map<String, dynamic>> formFourcontacts =
        await _database.query(ContactsManager.tableName, where: 'form = ("Form4")');
    return List.generate(formFourcontacts.length, (i) {
      return Contacts(
        fatherNumber: formFourcontacts[i][ContactsManager.fatherNumber],
        form: formFourcontacts[i][ContactsManager.form],
        guardianNumber: formFourcontacts[i][ContactsManager.guardianNumber],
        motherNumber: formFourcontacts[i][ContactsManager.motherNumber],
      );
    });
  }
  Future<void> deleteAll() async {
    await openDB();
    await _database.delete(tableName);
  }
}
