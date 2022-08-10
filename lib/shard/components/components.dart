import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:untitled/shard/cubit/cubit.dart';

Widget buildTaskItem(Map model,context){
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction){
      AppCubit.get(context).deleteDate(id: model['id'] );

    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children:  [
           CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blueAccent,
            child:  Text(model['time']),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(model['title']),
                Text(model['date']),
              ],
            ),
          ),
          IconButton(onPressed: ()
          {
            AppCubit.get(context).updateDate(status: 'Done', id: model['id']);
          }, icon:Icon(Icons.check_box),color: Colors.green,),
          IconButton(onPressed: (){
            AppCubit.get(context).updateDate(status: 'archive', id: model['id']);
          }, icon:Icon(Icons.archive),color: Colors.black38)
        ],
      ),
    ),
  );
}
Widget buildBuilder({required List<Map>tasks}){
  return ConditionalBuilder(condition: tasks.isNotEmpty,
      builder: (context)=>ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          itemCount: tasks.length),
      fallback:(context )=> Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text('No Tasks Yet , Please add some Task',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey),)
          ],
        ),
      )
  );
}