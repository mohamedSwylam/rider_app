/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:rider_app/modules/Login_screen/login_screen.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/shared/styles/color.dart';
import 'package:rider_app/widget/fade_animation.dart';
import 'package:rider_app/widget/progress_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


class SignUpScreen extends StatelessWidget {
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderAppCubit, RiderAppStates>(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          navigateTo(context, LoginScreen());
        }
      },
      builder: (context, state) {
        var date = DateTime.now().toString();
        var dateparse = DateTime.parse(date);
        var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse
            .year}";
        var profileImage = RiderAppCubit
            .get(context)
            .profile;
        var cubit = RiderAppCubit.get(context);
        return ConditionalBuilder(
          condition: state is! SignUpLoadingState,
          builder: (context)=>Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h,),
                  FadeAnimation(.9,Center(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 16.w,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage: profileImage == null
                                ? NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',)
                                : FileImage(profileImage),
                            radius: 25.w,
                            backgroundColor: ColorsConsts.backgroundColor,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        'اختر طريقه',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: defaultColor,fontSize: 13.sp),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              RiderAppCubit.get(context).pickImageCamera();
                                              Navigator.pop(context);
                                            },
                                            splashColor: defaultColor,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      8.0),
                                                  child: Icon(
                                                    Icons.camera,
                                                    color:defaultColor,
                                                    size: 7.w,
                                                  ),
                                                ),
                                                Text(
                                                  'الكاميرا',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color:
                                                      ColorsConsts.title),
                                                )
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              RiderAppCubit.get(context).getProfileImage();
                                              Navigator.pop(context);
                                            },
                                            splashColor: defaultColor,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      8.0),
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 7.w,
                                                    color: defaultColor,
                                                  ),
                                                ),
                                                Text(
                                                  'المعرض',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color:
                                                      ColorsConsts.title),
                                                )
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              RiderAppCubit.get(context).remove();
                                              Navigator.pop(context);
                                            },
                                            splashColor: defaultColor,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      8.0),
                                                  child: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.red,
                                                    size: 7.w,
                                                  ),
                                                ),
                                                Text(
                                                  'حذف',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: CircleAvatar(
                            child: Center(
                              child:  Icon(
                                  Feather.camera,
                                  color: Colors.white,
                                  size: 6.w,
                                ),
                              ),
                            backgroundColor: defaultColor,
                            radius: 5.w,
                          ),
                        ),
                      ],
                    ),
                  ),),
                  SizedBox(height: 5.h,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: FadeAnimation(.9,Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(1.5,Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[300]))),
                            child: defaultFormFiled(
                                type: TextInputType.text,
                                controller: nameController,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "الاسم الذي ادخلته غير صالح";
                                  }
                                  return null;
                                },
                                hint:'ادخل اسمك',
                            ),
                          ),),
                          FadeAnimation(1.8,Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[300]))),
                            child: defaultFormFiled(
                                type: TextInputType.emailAddress,
                                controller: emailController,
                                validate: (String value) {
                                  if (value.isEmpty ||
                                      !value.contains('@')) {
                                    return  "بريد الكتروني غير صالح";
                                  }
                                  return null;
                                },
                              hint: "ادخل البريد الالكتروني",
                            ),
                          ),),
                          FadeAnimation(2.1,Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[300]))),
                            child: defaultFormFiled(
                                type: TextInputType.phone,
                                controller: phoneController,
                                validate: (String value) {
                                  if (value.isEmpty || value.length < 10) {
                                    return "رقم هاتف غير صالح";
                                  }
                                  return null;
                                },
                              hint: "ادخل رقم هاتفك",
                            ),
                          ),),
                          FadeAnimation(2.7,Container(
                            decoration: BoxDecoration(),
                            child: defaultFormFiled(
                                type: TextInputType.visiblePassword,
                                controller: passwordController,
                                validate: (String value) {
                                  if (value.isEmpty || value.length < 7) {
                                    return "كلمه المرور غير صالحه";
                                  }
                                  return null;
                                },
                                isPassword: RiderAppCubit.get(context).isPasswordShown,
                                suffixPressed: () {
                                  RiderAppCubit.get(context)
                                      .changePasswordVisibility();
                                },
                              hint:"ادخل كلمه المرور",
                            ),
                          ),),
                        ],
                      ),
                    ),),
                  ),
                  SizedBox(height: 5.h),
                  ConditionalBuilder(
                    condition: state is! LoginLoadingState,
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          if (formKey.currentState.validate()) {
                            RiderAppCubit.get(context).userSignUp(
                              password: passwordController.text,
                              email: emailController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                              joinedAt: formattedDate,
                              createdAt: Timestamp.now().toString(),
                              profileImage: RiderAppCubit.get(context).url,
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
                                'تسجيل',
                                style: TextStyle(
                                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp),
                              )),
                        ),
                      );
                    },
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ),
          fallback: (context) => ProgressDialog('....  جاري انشاء الحساب  برجاء الانتظار'),
        );
      },
    );
  }
}
*/
