import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/modules/Login_screen/login_screen.dart';
import 'package:rider_app/modules/landingPage/landing_page.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/shared/styles/color.dart';
import 'package:rider_app/widget/fade_animation.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    )..repeat(min: 0,max: 1.0);
    _animation=CurvedAnimation(parent: _controller, curve: Curves.linear,);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () => navigateAndFinish(context, LoginScreen()));
    var cubit = AppCubit.get(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            FadeAnimation(
              1.2,
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'splash',
                    transitionOnUserGestures: true,
                    child: Lottie.asset('assets/images/car.json',width:80.w,height: 30.h),
                    ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "اوبر اشمون",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: defaultColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
