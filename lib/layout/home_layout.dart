import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/shard/cubit/cubit.dart';
import 'package:untitled/shard/cubit/states.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);
  Database? dataBase;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldKey,
            body: ConditionalBuilder(
              builder: (context) => cubit.screens[cubit.index],
              condition: cubit.tasks.isNotEmpty,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            appBar: AppBar(
              title: Text(cubit.titles[cubit.index]),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isShownBottomSheet) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDataBase(
                          title: textEditingController.text,
                          date: dateEditingController.text,
                          time: timeEditingController.text);
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                            (context) => Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(20),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'title must not null';
                                            }
                                            return null;
                                          },
                                          controller: textEditingController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              label: const Text('Task title'),
                                              prefixIcon:
                                                  const Icon(Icons.title)),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          onTap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) =>
                                                    timeEditingController.text =
                                                        value!
                                                            .format(context)
                                                            .toString());
                                          },
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return ' time must not null';
                                            }
                                            return null;
                                          },
                                          controller: timeEditingController,
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              label: const Text('Task time'),
                                              prefixIcon: const Icon(
                                                  Icons.watch_later_outlined)),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        "2022-8-21"))
                                                .then((value) => {
                                                      dateEditingController
                                                              .text =
                                                          DateFormat.yMMMd()
                                                              .format(value!)
                                                    });
                                          },
                                          child: TextFormField(
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return ' Date must not null';
                                              }
                                              return null;
                                            },
                                            controller: dateEditingController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                label: const Text('Task Date'),
                                                prefixIcon: const Icon(
                                                    Icons.calendar_month)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 20)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheet(isShown: false, icon: Icons.edit);
                    });

                    cubit.changeBottomSheet(isShown: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fTabButton)),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.index,
              onTap: (currentIndex) {
                cubit.change(currentIndex);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived')
              ],
            ),
          );
        },
      ),
    );
  }
}
