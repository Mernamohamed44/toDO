import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shard/components/components.dart';
import '../shard/cubit/cubit.dart';
import '../shard/cubit/states.dart';
class DoneTask extends StatelessWidget{
  const DoneTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;
          return buildBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }

}