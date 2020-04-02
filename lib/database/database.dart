import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/schoolDetails.dart';
import 'package:walgotech_final/models/sms.dart';

Database db;
Database _database;

class DBManager {
  static const databaseName = 'walgotechApp.db';
}

Future openDB() async {
  if (_database == null) {
    _database = await openDatabase(join(await getDatabasesPath(), DBManager.databaseName), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE parentContacts ("
          "id INTEGER PRIMARY KEY,"
          "motherNumber TEXT,"
          "fatherNumber TEXT,"
          "guardianNumber TEXT,"
          "form TEXT,"
          "admission TEXT,"
          "streams TEXT"
          ")");
      await db.execute("CREATE TABLE teacherContacts ("
          "id INTEGER PRIMARYKEY,"
          "firstName TEXT,"
          "lastName TEXT,"
          "phoneNumber TEXT"
          ")");
      await db.execute("CREATE TABLE subordinate ("
          "id INTEGER PRIMARYKEY,"
          "firstName TEXT,"
          "lastName TEXT,"
          "phone TEXT"
          ")");
      await db.execute("CREATE TABLE classes ("
          "id INTEGER PRIMARYKEY,"
          "classes TEXT"
          ")");
      await db.execute("CREATE TABLE school ("
          "id INTEGER PRIMARYKEY,"
          "schoolName TEXT,"
          "smsKey TEXT,"
          "smsID TEXT"
          ")");
      await db.execute("CREATE TABLE streams ("
          "id INTEGER PRIMARYKEY,"
          "streams TEXT"
          ")");
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

class SmsManager {
  static const number = 'number';
  static const messageTable = 'messages';
  static const teacherMessage = 'teacherMessages';
  static const id = 'id';
  static const message = 'message';
  static const sender = 'sender';
  static const date = 'date';
  static const recipent = 'recipent';

  Future<int> insertSMS(SMS sms) async {
    await openDB();
    return await _database.insert(SmsManager.messageTable, sms.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addParentsContacts(ParentsContacts contact) async {
    await openDB();
    return await _database.insert(ParentsContactsManager.tableName, contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addSchool(SchoolDetails details) async {
    await openDB();
    return await _database.insert(SchoolManager.tableName, details.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addTeacherContacts(TeacherContacts contact) async {
    await openDB();
    return await _database.insert(TeacherManager.tableName, contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addSubordinateContacts(SubOrdinateContact contact) async {
    await openDB();
    return await _database.insert(SubOrdinateManager.tableName, contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addClass(CurrentClasses currentClasses) async {
    await openDB();
    return await _database.insert(ClassesManager.tableName, currentClasses.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addStream(CurrentStreams contact) async {
    await openDB();
    return await _database.insert(StreamsManager.tableName, contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CurrentStreams>> getallStreams() async {
    await openDB();
    final List<Map<String, dynamic>> streams = await _database.rawQuery("SELECT * FROM streams");
    return List.generate(streams.length, (s) {
      return CurrentStreams(
        streams: streams[s][StreamsManager.streams],
      );
    });
  }

  Future<List<SchoolDetails>> getSchoolDetails() async {
    await openDB();
    final List<Map<String, dynamic>> school = await _database.rawQuery("SELECT * FROM school");
    return List.generate(school.length, (s) {
      return SchoolDetails(
        schoolName: school[s][SchoolManager.schoolName],
        smsID: school[s][SchoolManager.smsID],
        smsKey: school[s][SchoolManager.smsKey],
      );
    });
  }

  Future<List<CurrentClasses>> getallClasses() async {
    await openDB();
    final List<Map<String, dynamic>> classes = await _database.query(ClassesManager.tableName, orderBy: 'id ');
    return List.generate(classes.length, (c) {
      return CurrentClasses(
        registeredClasses: classes[c][ClassesManager.className],
      );
    });
  }

  Future<List<TeacherContacts>> getAllTeacherContacts() async {
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

  Future<List<ParentsContacts>> getParentContacts(String form) async {
    await openDB();
    final List<Map<String, dynamic>> contacts =
        await _database.query(ParentsContactsManager.tableName, where: 'form = ?', whereArgs: [form]);
    return List.generate(contacts.length, (i) {
      return ParentsContacts(
        fatherNumber: contacts[i][ParentsContactsManager.fatherNumber],
        motherNumber: contacts[i][ParentsContactsManager.motherNumber],
        guardianNumber: contacts[i][ParentsContactsManager.guardianNumber],
        form: contacts[i][ParentsContactsManager.form],
        admission: contacts[i][ParentsContactsManager.admission],
        streams: contacts[i][ParentsContactsManager.streams],
      );
    });
  }

  Future<List<ParentsContacts>> getAllParentContacts() async {
    await openDB();
    final List<Map<String, dynamic>> contacts = await _database.query(ParentsContactsManager.tableName);
    return List.generate(contacts.length, (i) {
      return ParentsContacts(
        fatherNumber: contacts[i][ParentsContactsManager.fatherNumber],
        motherNumber: contacts[i][ParentsContactsManager.motherNumber],
        guardianNumber: contacts[i][ParentsContactsManager.guardianNumber],
        form: contacts[i][ParentsContactsManager.form],
        admission: contacts[i][ParentsContactsManager.admission],
        streams: contacts[i][ParentsContactsManager.streams],
      );
    });
  }

  Future<List<ParentsContacts>> getStreamsContacts(String classname, String stream) async {
    await openDB();
    final List<Map<String, dynamic>> contacts = await _database
        .query(ParentsContactsManager.tableName, where: 'form = ? AND streams = ? ', whereArgs: [classname, stream]);
    return List.generate(contacts.length, (i) {
      return ParentsContacts(
        fatherNumber: contacts[i][ParentsContactsManager.fatherNumber],
        motherNumber: contacts[i][ParentsContactsManager.motherNumber],
        guardianNumber: contacts[i][ParentsContactsManager.guardianNumber],
        form: contacts[i][ParentsContactsManager.form],
        admission: contacts[i][ParentsContactsManager.admission],
        streams: contacts[i][ParentsContactsManager.streams],
      );
    });
  }

  Future<List<SubOrdinateContact>> getSubordinateContacts() async {
    await openDB();
    final List<Map<String, dynamic>> contacts = await _database.query(SubOrdinateManager.tableName);
    return List.generate(contacts.length, (i) {
      return SubOrdinateContact(
        firstName: contacts[i][SubOrdinateManager.firstName],
        lastName: contacts[i][SubOrdinateManager.lastName],
        phone: contacts[i][SubOrdinateManager.phone],
      );
    });
  }

  Future<List<SMS>> getParentsSMSList() async {
    await openDB();
    final List<Map<String, dynamic>> sms = await _database.query(SmsManager.messageTable);
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

  Future<void> deleteAll() async {
    await openDB();
    await _database.delete(messageTable);
  }
}

class ParentsContactsManager {
  static const tableName = 'parentContacts';
  static const motherNumber = 'motherNumber';
  static const fatherNumber = 'fatherNumber';
  static const guardianNumber = 'guardianNumber';
  static const form = 'form';
  static const admission = 'admission';
  static const streams = 'streams';
}

class TeacherManager {
  static const id = 'id';
  static const tableName = 'teacherContacts';
  static const phoneNumber = 'phoneNumber';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
}

class ClassesManager {
  static const id = 'id';
  static const className = 'classes';
  static const tableName = 'classes';
}

class StreamsManager {
  static const id = 'id';
  static const streams = 'streams';
  static const tableName = 'streams';
}

class StreamClassManager {
  static const streams = 'streams';
  static const classes = 'classes';
}

class SubOrdinateManager {
  static const tableName = 'subordinate';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const phone = 'phone';
}

class SchoolManager {
  static const tableName = 'school';
  static const schoolName = 'schoolName';
  static const address = 'address';
  static const city = 'city';
  static const email = 'email';
  static const phone = 'phone';
  static const schoolMotto = 'regname';
  static const smsKey = 'smsKey';
  static const smsUserName = 'smsUserName';
  static const smsID = 'smsID';
}
