import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/custom_icons.dart';
import 'package:lol/screens/chat_details.dart';

import '../models/user_model.dart';
class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    AppCubit.get(context).getUsers();
    return BlocConsumer<AppCubit  , AppStates>(builder: (context, state) {
      return SafeArea(
         minimum: EdgeInsets.only(top: 10),
        child: Scaffold(appBar:
        AppBar(title: Text('Chats' ,style: TextStyle(fontWeight: FontWeight.bold ),),),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container (
                height: 40,
                child: TextField(decoration: InputDecoration
                  (border: OutlineInputBorder(borderRadius:
                BorderRadius.all(Radius.circular(10)))
                , hintText: 'Search..' , suffixIcon: Icon(CustomIcons.search)),),
              ),
            ) ,
            Expanded(
              child: ListView.separated(itemBuilder: (context, index) {
                return chatBuilder(AppCubit.get(context).users[index], context) ;
              }, separatorBuilder: (context ,index) => const SizedBox(height: 0,), itemCount: AppCubit.get(context).users.length),
            ),
          ],
        ) ,),
      );
    }, listener: (context ,state){});
  }
}
Widget chatBuilder (UserModel user , context )
{
  return InkWell
    (
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatDetailsScreen(userModel: user)));
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row
        (children: [
        CircleAvatar(backgroundImage: NetworkImage('${user.image}'),),
        SizedBox(width: 10,)  ,
        Expanded(child: Text('${user.name}'))
      ],),
    ),
  );
}
