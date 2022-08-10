import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shard/components/components.dart';
import 'package:untitled/shard/cubit/cubit.dart';
import 'package:untitled/shard/cubit/states.dart';

class NewTask extends StatelessWidget {
  const NewTask({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          return buildBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
