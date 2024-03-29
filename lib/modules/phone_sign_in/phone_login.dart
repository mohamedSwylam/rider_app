/*
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:rider_app/layout/rider_layout.dart';
import 'package:rider_app/modules/phone_sign_in/phone_verifcation.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/shared/network/local/cache_helper.dart';
import 'package:rider_app/shared/styles/color.dart';
import 'package:rider_app/widget/fade_animation.dart';

import 'package:sizer/sizer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class PhoneLoginScreen extends StatelessWidget {
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var addressController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderAppCubit, RiderAppStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(text: state.error, state: ToastState.ERROR);
        }
        if (state is LoginSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            navigateAndFinish(context, RiderLayout());
          });
          RiderAppCubit.get(context).selectedHome();
        }
      },
      builder: (context, state) {
        var date = DateTime.now().toString();
        var dateparse = DateTime.parse(date);
        var formattedDate =
            "${dateparse.day}-${dateparse.month}-${dateparse.year}";
        var profileImage = RiderAppCubit.get(context).profile;
        var cubit = RiderAppCubit.get(context);
        return Directionality(
          textDirection:
              cubit.isEn == false ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 1,
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [Colors.amber, Colors.teal],
                            [Colors.amberAccent, Colors.green[100]],
                          ],
                          durations: [19440, 10800],
                          heightPercentages: [0.20, 0.25],
                          blur: MaskFilter.blur(BlurStyle.solid, 10),
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        waveAmplitude: 0,
                        size: Size(
                          double.infinity,
                          double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 7.h,
                        ),
                        FadeAnimation(
                          .9,
                          Center(
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 16.w,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundImage: profileImage == null
                                        ? NetworkImage(
                                            'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                                          )
                                        : FileImage(profileImage),
                                    radius: 25.w,
                                    backgroundColor:
                                        ColorsConsts.backgroundColor,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Center(
                                              child: Text(
                                                cubit.getTexts('signUp1'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: defaultColor,
                                                    fontSize: 13.sp),
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      RiderAppCubit.get(context)
                                                          .pickImageCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    splashColor: defaultColor,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.camera,
                                                            color: Colors
                                                                .yellow[700],
                                                            size: 7.w,
                                                          ),
                                                        ),
                                                        Text(
                                                          cubit.getTexts(
                                                              'signUp2'),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  ColorsConsts
                                                                      .title),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      RiderAppCubit.get(context)
                                                          .getProfileImage();
                                                      Navigator.pop(context);
                                                    },
                                                    splashColor: defaultColor,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.image,
                                                            size: 7.w,
                                                            color: Colors
                                                                .yellow[700],
                                                          ),
                                                        ),
                                                        Text(
                                                          cubit.getTexts(
                                                              'signUp3'),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  ColorsConsts
                                                                      .title),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      RiderAppCubit.get(context)
                                                          .remove();
                                                      Navigator.pop(context);
                                                    },
                                                    splashColor: defaultColor,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.remove_circle,
                                                            color: Colors.red,
                                                            size: 7.w,
                                                          ),
                                                        ),
                                                        Text(
                                                          cubit.getTexts(
                                                              'signUp4'),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.red),
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
                                      child: Icon(
                                        Feather.camera,
                                        color: Colors.white,
                                        size: 6.w,
                                      ),
                                    ),
                                    backgroundColor: Colors.yellow[700],
                                    radius: 5.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 23.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: FadeAnimation(
                            .9,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                children: <Widget>[
                                  FadeAnimation(
                                    1.5,
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[300]))),
                                      child: defaultFormFiled(
                                        type: TextInputType.phone,
                                        controller: phoneController,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          child: Text(
                                            " (+2) ",
                                            style: TextStyle(color:Colors.grey, fontSize: 12.sp),
                                          ),
                                        ),
                                        validate: (String value) {
                                          if (value.isEmpty ||
                                              value.length < 10) {
                                            return '${cubit.getTexts('signUp9')}';
                                          }
                                          return null;
                                        },
                                        hint: cubit.getTexts('signUp10'),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    1.8,
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[300]))),
                                      child: defaultFormFiled(
                                        type: TextInputType.text,
                                        controller: nameController,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return '${cubit.getTexts('signUp5')}';
                                          }
                                          return null;
                                        },
                                        hint: cubit.getTexts('signUp6'),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    2.1,
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[300]))),
                                      child: defaultFormFiled(
                                        type: TextInputType.text,
                                        controller: addressController,
                                        validate: (String value) {
                                          if (value.isEmpty ||
                                              value.length < 5) {
                                            return '${cubit.getTexts('signUp11')}';
                                          }
                                          return null;
                                        },
                                        hint: cubit.getTexts('signUp12'),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    2.4,
                                    Container(
                                      decoration: BoxDecoration(),
                                      child: defaultFormFiled(
                                        type: TextInputType.visiblePassword,
                                        controller: passwordController,
                                        validate: (String value) {
                                          if (value.isEmpty ||
                                              value.length < 7) {
                                            return '${cubit.getTexts('signUp13')}';
                                          }
                                          return null;
                                        },
                                        isPassword: RiderAppCubit.get(context)
                                            .isPasswordShown,
                                        suffixPressed: () {
                                          RiderAppCubit.get(context)
                                              .changePasswordVisibility();
                                        },
                                        hint: cubit.getTexts('signUp14'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) {
                            return InkWell(
                              onTap: () {
                                if (formKey.currentState.validate()) {
                                  cubit.verifyPhoneNumber("+2${phoneController.text}", context, cubit.setData);
                                  navigateTo(context, PhoneVerficationScreen(
                                    password: passwordController.text,
                                    address: addressController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    profile:
                                    '${cubit.url}',
                                  ));
                                }
                              },
                              child: Container(
                                width: 30.w,
                                height: 11.h,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.yellow[700]),
                                child: Center(
                                    child: Text(
                                  cubit.getTexts('signUp15'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
