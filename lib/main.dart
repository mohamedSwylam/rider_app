import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rider_app/shared/bloc_observer.dart';
import 'package:rider_app/shared/components/constants.dart';
import 'package:rider_app/shared/network/local/cache_helper.dart';
import 'package:rider_app/shared/network/remote/dio_helper.dart';
import 'package:rider_app/shared/styles/themes.dart';
import 'package:sizer/sizer.dart';
import 'package:device_preview/device_preview.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'layout/rider_layout.dart';
import 'modules/landingPage/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(MyApp());}
class MyApp extends StatelessWidget
{
  MyApp();

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => AppCubit()),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Sizer(
            builder: (context, orientation, deviceType)=> MaterialApp(
              builder: DevicePreview.appBuilder,
              title: 'taxi Rider App',
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              theme: lightTheme,
              home: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
//  runApp(DevicePreview(builder: (context) =>MyApp(isDark: isDark,startWidget: widget,isEn: isEn,),));} runApp(MyApp(isDark: isDark,startWidget: widget,isEn: isEn,),);}
