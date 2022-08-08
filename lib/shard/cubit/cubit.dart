import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/shard/cubit/states.dart';

import '../../modules/archeived_screen.dart';
import '../../modules/done_screen.dart';
import '../../modules/tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  bool isShownBottomSheet = false;
  IconData fTabButton = Icons.edit;
  int index = 0;
  List<Widget> screens = [
    const NewTask(),
    const DoneTask(),
    const ArchivedTask()
  ];
  List<String> titles = ['New Task', 'Done Task', 'Archived Task'];

  void change(int currentIndex) {
    index = currentIndex;
    emit(ChangeBottomNavBarState());
  }

  Database? dataBase;
  List<Map> tasks = [];
  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (dataBase, version) {
      if (kDebugMode) {
        print('dataBase created');
      }
      dataBase
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT ,date TEXT, time TEXT)')
          .then((value) => print('table created'))
          .catchError((error) {
        if (kDebugMode) {
          print('Error when creating table');
        }
      });
    }, onOpen: (dataBase) {
      getFromDataBase(dataBase).then((value) {
        tasks = value;
        emit(AppGetDataBaseState());
      });
      if (kDebugMode) {
        print('dataBase opened');
      }
    }).then((value) {
      dataBase = value;
      emit(AppCreateDataBaseState());
    });
  }

  Future<List<Map>> getFromDataBase(dataBase) async {
    return tasks = await dataBase!.rawQuery('SELECT * FROM tasks');
  }

  insertToDataBase({String? title, String? time, String? date}) async {
    await dataBase?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time) VALUES("$title","$date","$time")')
          .then((value) {
        print('Insert successfully');
        emit(AppInsertDataBaseState());
        getFromDataBase(dataBase).then((value) {
          tasks = value;
          emit(AppGetDataBaseState());
        });
      }).catchError((error) {
        if (kDebugMode) {
          print('Errors is ${error.toString()}');
        }
      });
    });
  }

  void changeBottomSheet({required bool isShown, required IconData icon}) {
    isShownBottomSheet = isShown;
    fTabButton = icon;
    emit(AppChangeBottomSheetBarState());
  }
}
