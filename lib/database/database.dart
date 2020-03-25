import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';

Database db;


class SmsManager {
  Database _database;
  static const databaseName = 'messages.db';
  static const number = 'number';
  static const parentsMesage = 'parentMessages';
  static const teacherMessage = 'teacherMessages';
  static const id = 'id';
  static const message = 'message';
  static const sender = 'sender';
  static const date = 'date';
  static const recipent = 'recipent';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), SmsManager.databaseName), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE parentMessages ("
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
    return await _database.insert(SmsManager.parentsMesage, sms.toMap());
  }
  Future<int> insertTeacherSMS(SMS sms) async {
    await openDB();
    return await _database.insert(SmsManager.teacherMessage, sms.toMap());
  }

  Future<List<SMS>> getParentsSMSList() async {
    await openDB();
    final List<Map<String, dynamic>> sms = await _database.query(SmsManager.parentsMesage);
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
  Future<List<SMS>> getTeachersSMSList() async {
    await openDB();
    final List<Map<String, dynamic>> sms = await _database.query(SmsManager.teacherMessage);
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
      SmsManager.parentsMesage,
      sms.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteSMS(int id) async {
    await openDB();
    await _database.delete(
      SmsManager.parentsMesage,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    await openDB();
    await _database.delete(parentsMesage);
  }
}

class ParentsContactsManager {
  Database _database;
  static const databaseName = 'messages.db';
  static const id = 'id';
  static const tableName = 'parentsContacts';
  static const motherNumber = 'motherNumber';
  static const fatherNumber = 'fatherNumber';
  static const guardianNumber = 'guardianNumber';
  static const form = 'form';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), ParentsContactsManager.databaseName),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE parentsContacts ("
            "id INTEGER PRIMARYKEY,"
            "fatherNumber TEXT,"
            "motherNumber TEXT,"
            "guardianNumber TEXT,"
            "form TEXT"
            ")");
      });
    }
  }

  Future<int> addParentsContacts(ParentsContacts contact) async {
    await openDB();
    return await _database.insert('parentsContacts', contact.toMap());
  }

  Future<List<ParentsContacts>> getAllContacts() async {
    await openDB();
    final List<Map<String, dynamic>> contacts = await _database.query(ParentsContactsManager.tableName);
    return List.generate(contacts.length, (i) {
      return ParentsContacts(
          fatherNumber: contacts[i][ParentsContactsManager.fatherNumber],
          motherNumber: contacts[i][ParentsContactsManager.motherNumber],
          guardianNumber: contacts[i][ParentsContactsManager.guardianNumber],
          form: contacts[i][ParentsContactsManager.form]);
    });
  }

  Future<List<ParentsContacts>> getFormOne() async {
    await openDB();
    final List<Map<String, dynamic>> formOnecontacts =
        await _database.query(ParentsContactsManager.tableName, where: 'form = ("Form1")');
    return List.generate(formOnecontacts.length, (i) {
      return ParentsContacts(
        fatherNumber: formOnecontacts[i][ParentsContactsManager.fatherNumber],
        form: formOnecontacts[i][ParentsContactsManager.form],
        guardianNumber: formOnecontacts[i][ParentsContactsManager.guardianNumber],
        motherNumber: formOnecontacts[i][ParentsContactsManager.motherNumber],
      );
    });
  }
   Future<List<ParentsContacts>> getFormTwo() async {
    await openDB();
    final List<Map<String, dynamic>> formTwocontacts =
        await _database.query(ParentsContactsManager.tableName, where: 'form = ("Form2")');
    return List.generate(formTwocontacts.length, (i) {
      return ParentsContacts(
        fatherNumber: formTwocontacts[i][ParentsContactsManager.fatherNumber],
        form: formTwocontacts[i][ParentsContactsManager.form],
        guardianNumber: formTwocontacts[i][ParentsContactsManager.guardianNumber],
        motherNumber: formTwocontacts[i][ParentsContactsManager.motherNumber],
      );
    });
  }
  Future<List<ParentsContacts>> getFormThree() async {
    await openDB();
    final List<Map<String, dynamic>> formThreecontacts =
        await _database.query(ParentsContactsManager.tableName, where: 'form = ("Form3")');
    return List.generate(formThreecontacts.length, (i) {
      return ParentsContacts(
        fatherNumber: formThreecontacts[i][ParentsContactsManager.fatherNumber],
        form: formThreecontacts[i][ParentsContactsManager.form],
        guardianNumber: formThreecontacts[i][ParentsContactsManager.guardianNumber],
        motherNumber: formThreecontacts[i][ParentsContactsManager.motherNumber],
      );
    });
  }
  Future<List<ParentsContacts>> getFormFour() async {
    await openDB();
    final List<Map<String, dynamic>> formFourcontacts =
        await _database.query(ParentsContactsManager.tableName, where: 'form = ("Form4")');
    return List.generate(formFourcontacts.length, (i) {
      return ParentsContacts(
        fatherNumber: formFourcontacts[i][ParentsContactsManager.fatherNumber],
        form: formFourcontacts[i][ParentsContactsManager.form],
        guardianNumber: formFourcontacts[i][ParentsContactsManager.guardianNumber],
        motherNumber: formFourcontacts[i][ParentsContactsManager.motherNumber],
      );
    });
  }
  Future<void> deleteAll() async {
    await openDB();
    await _database.delete(tableName);
  }
}

class TeacherManager{
   Database _database;
  static const databaseName = 'messaging.db';
  static const id = 'id';
  static const tableName = 'teachers';
  static const phoneNumber = 'phoneNumber';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
 
 Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), TeacherManager.databaseName),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE teachers ("
            "id INTEGER PRIMARYKEY,"
            "firstName TEXT,"
            "lastName TEXT,"
            "phoneNumber TEXT"
            ")");
      });
    }
  }
  Future<int> addContacts(TeacherContacts contact) async {
    await openDB();
    return await _database.insert('teachers', contact.toMap());
  }

  Future<List<TeacherContacts>> getAllContacts() async {
    await openDB();
    final List<Map<String, dynamic>> contacts = await _database.query(TeacherManager.tableName);
    return List.generate(contacts.length, (i) {
      return TeacherContacts(
          firstName: contacts[i][TeacherManager.firstName],
          lastName: contacts[i][TeacherManager.lastName],
          phoneNumber: contacts[i][TeacherManager.phoneNumber],
          );
    });
  }
}