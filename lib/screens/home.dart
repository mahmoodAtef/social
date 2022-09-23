// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/constants.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/models/comment_model.dart';
import 'package:lol/models/post_model.dart';
import 'package:lol/models/user_model.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../custom_icons.dart';

class HomeScreen extends StatelessWidget {
  var uid = userId;
  HomeScreen({this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppCubit.get(context).getUserData(uid);
    // UserModel user = AppCubit.get(context).userModel;
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) => Scaffold(
              bottomNavigationBar: ScrollNavigation(
                physics: false,
                identiferStyle: const NavigationIdentiferStyle(
                  color: Colors.purple,
                  width: 3,
                ),
                bodyStyle: const NavigationBodyStyle(
                  physics: NeverScrollableScrollPhysics(),
                  background: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                barStyle: const NavigationBarStyle(
                  verticalPadding: 13,
                  activeColor: Colors.purple,
                  background: Colors.white,
                  elevation: 1.0,
                ),
                pages: AppCubit.get(context).Screens,
                items: AppCubit.get(context).bottomitems,
                showIdentifier: true,
                initialPage: 1,
              ),
            ),
        listener: (context, state) {});
  }
}

