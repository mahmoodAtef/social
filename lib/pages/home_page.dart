
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/custom_icons.dart';
import 'package:lol/screens/new_post.dart';
import 'package:lol/screens/register.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../network/local/cache_helper.dart';
import '../screens/home.dart';

class HomePage extends StatelessWidget {

   const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
   late File ? commentImage =  AppCubit.get(context).commentImage ;
    UserModel user = UserModel();
    AppCubit.get(context).getUserData(userId).then((value)
    async {
      user =  AppCubit.get(context).userModel;
      print (user.name);
      AppCubit.get(context).getPosts(user);
    });
    print ('my uid is: $userId');
    // AppCubit.get(context).getUserData(uid);
CarouselController controller = CarouselController();
        return BlocConsumer<AppCubit, AppStates> (
          listener: (context , state){

        }, builder: (context, state) {
          return  SafeArea(
            child: Scaffold(
              appBar: AppBar(title: Text('Social App'),
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(onPressed: ()
                  {
                    AppCubit.get(context).imagesList = [];
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> NewPostScreen(model: user,)));
                  }, icon:Icon(Icons.post_add_sharp) ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.search_sharp, )),
                ],
              ),
              body: AppCubit.get(context).posts.isEmpty ? Center(child: CircularProgressIndicator()):
              SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child:
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => PostBuilder(context ,controller ,
                        AppCubit.get(context).posts[index] , index , user, commentImage),itemCount:
                  AppCubit.get(context).posts.length,shrinkWrap: true,)) ,
            ),
          );
        },);
      }
  }

