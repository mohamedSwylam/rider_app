
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/shared/styles/color.dart';
import 'package:rider_app/widget/fade_animation.dart';
import 'package:sizer/sizer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'forgot_password_dialog.dart';

class ForgetPasswordScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderAppCubit, RiderAppStates>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          showDialog(
            context: context,
            builder: (BuildContext context) => ForgotPasswordDialog(),
          );
          emailController.clear();
        }
      },
      builder: (context, state) {
        var cubit = RiderAppCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Hero(
                    tag: 'splash',
                    child: Lottie.asset('assets/images/car.json',repeat: false,width:40.w,height: 15.h),

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        FadeAnimation(
                          1.5,
                          Text(
                            'اعاده تعيين كلمه المرور',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 15.sp),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        FadeAnimation(
                            1.5,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.white))),
                                    child: defaultFormFiled(
                                        type: TextInputType.emailAddress,
                                        controller: emailController,
                                        validate: (String value) {
                                          if (value.isEmpty ||
                                              !value.contains('@')) {
                                            return '${cubit.getTexts('forgetPass4')}';
                                          }
                                          return null;
                                        },
                                        hint:'البريد الالكتروني'),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 5.h,
                        ),
                        FadeAnimation(
                            1.8,
                            ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) {
                                return InkWell(
                                  onTap: () {
                                    if (formKey.currentState.validate()) {
                                      RiderAppCubit.get(context).userForgetPassword(
                                        email: emailController.text,
                                      );
                                    }

                                  },
                                  child: Container(
                                    width: 32.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: defaultColor),
                                    child: Center(
                                        child: Text(
                                          "ارسال",
                                          style: TextStyle(
                                              color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14.sp),
                                        )),
                                  ),
                                );
                              },
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator()),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
