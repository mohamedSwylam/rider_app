
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:rider_app/layout/rider_layout.dart';
import 'package:rider_app/modules/Login_screen/cubit/cubit.dart';
import 'package:rider_app/modules/sign_up_screen/sign_up_screen.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/shared/network/local/cache_helper.dart';
import 'package:rider_app/shared/styles/color.dart';
import 'package:rider_app/widget/progress_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../shared/components/custom_text_field.dart';
import 'cubit/states.dart';
import 'forget_password.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
    /*    if (state is LoginErrorState) {
          showToast(text: state.error, state: ToastState.ERROR);
        }
        if (state is LoginSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            navigateAndFinish(context, RiderLayout());
          });
          RiderAppCubit.get(context).selectedHome();
        }*/
      },
      builder: (context, state) {
        var cubit = LoginAppCubit.get(context);
        return ConditionalBuilder(
          condition: state is ! LoginLoadingState,
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Hero(
                        tag: 'splash',
                        child: Lottie.asset('assets/images/car.json',repeat: false,width:40.w,height: 15.h),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        '...مرحبا',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                      Text(
                        'سجل دخولك للاستمرار',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
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
                                          color: Colors.grey.shade300))),
                              child: CustomTextFormField(
                                inputType: TextInputType.emailAddress,
                                controller: emailController,
                                validator: (String? value) {
                                  if (value!.isEmpty ||
                                      !value.contains('@')) {
                                    return '${cubit.getTexts('login6')}';
                                  }
                                  return null;
                                },
                                hintText: 'البريد الالكتروني',
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(),
                              child: CustomTextFormField(
                                inputType: TextInputType.visiblePassword,
                                controller: passwordController,
                                validator: (String? value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return '${cubit.getTexts('login7')}';
                                  }
                                  return null;
                                },
                                isPassword: RiderAppCubit.get(context)
                                    .isPasswordShown,
                                hintText: 'كلمه المرور',
                              ),
                            ),
                          ],
                        ),
                      )
                      SizedBox(
                        height: 3.h,
                      ),
                      FadeAnimation(
                        1.8,
                        InkWell(
                          onTap: () {
                            navigateTo(context, ForgetPasswordScreen());
                          },
                          child: Text(
                            'نسيت كلمه المرور  ؟',
                            style:
                                TextStyle(color: Colors.black, fontSize: 11.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      FadeAnimation(
                          2.1,
                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) {
                              return InkWell(
                                onTap: () {
                                  if (formKey.currentState.validate()) {
                                    RiderAppCubit.get(context).userLogin(
                                      password: passwordController.text,
                                      email: emailController.text,
                                    );
                                  }
                                },
                                child: Container(
                                  width: 30.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: defaultColor),
                                  child: Center(
                                      child: Text(
                                    'دخول',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp),
                                  )),
                                ),
                              );
                            },
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          )),
                      SizedBox(
                        height: 3.h,
                      ),
                      FadeAnimation(
                        2.3,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateTo(context, SignUpScreen());
                                },
                                child: Text(
                                  'انشاء حساب',
                                  style:
                                  TextStyle(color: defaultColor, fontSize: 13.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Text(
                                'ليس لديك حساب',
                                style:
                                TextStyle(color: Colors.black, fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          fallback: (context) => ProgressDialog('....  جاري تسجيل الدخول برجاء الانتظار'),
        );
      },
    );
  }
}
*/
