import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shard/components/components.dart';
import 'package:untitled/shard/cubit/cubit.dart';
import 'package:untitled/shard/cubit/states.dart';

class ArchivedTask extends StatelessWidget {
  const ArchivedTask({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).archivedTasks;
          return buildBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
