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
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void createDataBase() async {
    dataBase = await openDatabase(
      'tod.db',
      version: 1,
      onCreate: (database, version) {
        print('data base created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT )')
            .then((value) {
          print('thr table is created');
        }).catchError((error) {
          print('error when creating table is ${error.toString()}');
        });
      },
      onOpen: (database) {
        getFromDataBase(database);
        print('database opended');
      },
    ).then((value) {
      return dataBase = value;
    });
  }

  void getFromDataBase(dataBase)  {
    newTasks = [];
    doneTasks = [];
     archivedTasks = [];
      emit(AppGetDataBaseLoadingState());
     dataBase!.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element) {
         if(element['status']=='new') {
           newTasks.add(element);
         } else if(element['status']=='done') {
           doneTasks.add(element);
         } else {
           archivedTasks.add(element);
         }
       });
       emit(AppGetDataBaseState());
     });
  }

  insertToDataBase({String? title, String? time, String? date}) async {
    await dataBase?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('Insert successfully');
        emit(AppInsertDataBaseState());
        getFromDataBase(dataBase);
      }).catchError((error) {
        if (kDebugMode) {
          print('Errors is ${error.toString()}');
        }
      });
    });
  }

  void updateDate({required String status, required int id}) async {
    dataBase?.rawUpdate('UPDATE  tasks SET status =? WHERE id=?', ['$status', id]).then((value){
      getFromDataBase(dataBase);
      emit(AppUpdateDataBaseState());
    });
  }
  void deleteDate({ required int id}) async {
    dataBase?.rawDelete('UPDATE  tasks SET status =? WHERE id=?', [id]).then((value){
      getFromDataBase(dataBase);
      emit(AppDeleteDataBase());
    });
  }

  void changeBottomSheet({required bool isShown, required IconData icon}) {
    isShownBottomSheet = isShown;
    fTabButton = icon;
    emit(AppChangeBottomSheetBarState());
  }
}
