import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/states.dart';

import '../cubit/cubit.dart';
class CommentsScreen  extends StatelessWidget {
  const CommentsScreen ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      return BlocConsumer<AppCubit, AppStates>(builder: (context, state) {
    return Scaffold(
      body: Column (children: [

      ],),
    );
      }, listener: (context, state){});
    });
  }
}
