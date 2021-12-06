import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/modules/Login_screen/forget_password.dart';
import 'package:rider_app/modules/landingPage/landing_page.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/widget/fade_animation.dart';
import 'package:sizer/sizer.dart';


class LandingPage extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var cubit = RiderAppCubit.get(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

          ],
        ),
      ),
    );
  }
}
