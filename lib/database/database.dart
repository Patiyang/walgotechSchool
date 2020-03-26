import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
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
          "form TEXT"
          ")");

      await db.execute("CREATE TABLE messages ("
          "id INTEGER PRIMARYKEY,"
          "message TEXT,"
          "sender TEXT,"
          "recipent TEXT,"
          "date TEXT"
          ")");

      await db.execute("CREATE TABLE classes ("
          "id INTEGER PRIMARYKEY,"
          "classes TEXT"
          ")");
      await db.execute("CREATE TABLE teacherContacts ("
          "id INTEGER PRIMARYKEY,"
          "firstName TEXT,"
          "lastName TEXT,"
          "phoneNumber TEXT"
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
    return await _database.insert(SmsManager.messageTable, sms.toMap());
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
  Database _database;
  static const id = 'id';
  static const tableName = 'parentContacts';
  static const motherNumber = 'motherNumber';
  static const fatherNumber = 'fatherNumber';
  static const guardianNumber = 'guardianNumber';
  static const form = 'form';

  // Future openDB() async {
  //   if (_database == null) {
  //     _database = await openDatabase(join(await getDatabasesPath(), DBManager.databaseName),
  //         version: 1, onCreate: (Database db, int version) async {});
  //   }
  // }

  Future<int> addParentsContacts(ParentsContacts contact) async {
    await openDB();
    return await _database.insert(ParentsContactsManager.tableName, contact.toMap());
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

  Future<void> query() async {
    await openDB();
    await _database.rawQuery("SELECT * FROM parentsContacts");
  }
}

class TeacherManager {
  Database _database;
  static const databaseName = 'school.db';
  static const id = 'id';
  static const tableName = 'teacherContacts';
  static const phoneNumber = 'phoneNumber';
  static const firstName = 'firstName';
  static const lastName = 'lastName';

  // Future openDB() async {
  //   if (_database == null) {
  //     _database = await openDatabase(join(await getDatabasesPath(), TeacherManager.databaseName), version: 1,
  //         onCreate: (Database db, int version) async {
  //       await db.execute("CREATE TABLE teacherContacts ("
  //           "id INTEGER PRIMARYKEY,"
  //           "firstName TEXT,"
  //           "lastName TEXT,"
  //           "phoneNumber TEXT"
  //           ")");
  //     });
  //   }
  // }

  Future<int> addContacts(TeacherContacts contact) async {
    await openDB();
    return await _database.insert(TeacherManager.tableName, contact.toMap());
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

// ==============================CLASSES==================================
class ClassesManager {
  Database _database;
  static const databaseName = 'shule.db';
  static const id = 'id';
  static const className = 'classes';
  static const tableName = 'classes';

  // Future openDB() async {
  //   if (_database == null) {
  //     _database = await openDatabase(join(await getDatabasesPath(), ClassesManager.databaseName), version: 1,
  //         onCreate: (Database db, int version) async {

  //     });
  //   }
  // }

  Future<int> addClass(CurrentClasses currentClasses) async {
    await openDB();
    return await _database.insert(tableName, currentClasses.toMap());
  }

  Future<List<CurrentClasses>> getallClasses() async {
    await openDB();
    final List<Map<String, dynamic>> classes = await _database.query(ClassesManager.tableName);
    return List.generate(classes.length, (c) {
      return CurrentClasses(
        registeredClasses: classes[c][ClassesManager.className],
      );
    });
  }
}

// ===========================STREAMS==============================
class StreamsManager {
  Database _database;
  static const databaseName = 'shule2.db';
  static const streamName = 'streamName';
  static const tableName = 'streams';

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), StreamsManager.databaseName), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE stream ("
            "streams TEXT"
            ")");
      });
    }
  }

  Future<int> addStream(CurrentStreams contact) async {
    await openDB();
    return await _database.insert(StreamsManager.tableName, contact.toMap());
  }

  Future<List<CurrentClasses>> getallStreams() async {
    await openDB();
    final List<Map<String, dynamic>> classes = await _database.query(StreamsManager.tableName);
    return List.generate(classes.length, (c) {
      return CurrentClasses(
        registeredClasses: classes[c][ClassesManager.className],
      );
    });
  }
}
