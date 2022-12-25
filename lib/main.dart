import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/screens/complete_data.dart';
import 'package:lol/screens/home.dart';
import 'package:lol/screens/login.dart';
import 'constants.dart';
import 'cubit/cubit.dart';
import 'network/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  // CacheHelper.removeData(key: 'uid');
  bool ? islogin = await CacheHelper.getData(key: 'isLogin');
  var _uid =  await CacheHelper.getData(key: 'uid');
  userId = _uid ;
  print(appUSer.name.toString());
  Widget  startScreen ;
  if (_uid != null )
  {
    startScreen = HomeScreen(uid: _uid,);
  }
  else{
    startScreen = LoginScreen();
  }
  await Firebase.initializeApp();
  runApp( MyApp( uid : _uid,startScreen: startScreen,));
}

class MyApp extends StatelessWidget {
  Widget startScreen ;
  var uid ;
  MyApp({this.uid, required this.startScreen, Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider
      (
      create: (BuildContext context) => AppCubit ()
      ,
      child: BlocConsumer<AppCubit, AppStates>
        (
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData
              (
              primarySwatch : Colors.purple,
              backgroundColor : Colors.grey.shade900,
              appBarTheme: AppBarTheme
                (
                  color: Colors.white,
                  elevation: 0.0,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              cardTheme: CardTheme(shadowColor: Colors.black),
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData(
              iconTheme: IconThemeData(color: Colors.white),
              scaffoldBackgroundColor: Colors.black54,
              appBarTheme: (AppBarTheme(
                  color: Colors.black45,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
              cardTheme: CardTheme(
                  shadowColor: Colors.white,
                  elevation: 10,
                  color: Colors.white),
            ),
            home: startScreen ,
          );
        },
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}