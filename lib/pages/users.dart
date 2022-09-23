import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/constants.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/custom_icons.dart';
import 'package:lol/models/user_model.dart';
  class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    List<UserModel> users =[];
    AppCubit.get(context).getUsers().then((value) {
      users = AppCubit.get(context).users ;
    });
    return BlocConsumer <AppCubit, AppStates>(builder: (context, state)
    {

     return  Scaffold(
       appBar: AppBar(),
       body:  users.length != 0 ? Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           children: [
             TextField(
               decoration :
               InputDecoration
                 (suffixIcon:
               Icon(CustomIcons.search),
                   hintText: 'Search.. ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
             )  ,
             Expanded(

               child: SingleChildScrollView(

                 child: ListView.separated(
                     shrinkWrap: true,
                     physics : NeverScrollableScrollPhysics(),itemBuilder:(context  , index) =>followerBuilder(AppCubit.get(
                     context).users[index], context),
                     separatorBuilder: (context  , index) => SizedBox(height: 10,),
                     itemCount: users.length),
               ),
             )
           ],
         ),
       ): const Center(child: CircularProgressIndicator()),
     );
    }, listener: (context, state){});
  }
}
