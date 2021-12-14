import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rider_app/shared/styles/color.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RiderLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderAppCubit, RiderAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RiderAppCubit.get(context);
        GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

        return Scaffold(
          key: scaffoldKey,
          drawer: Container(
            color: Colors.white,
            width: 70.w,
            child: Drawer(
              child: ListView(
                children: [
                  Container(
                    height: 30.h,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.white),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            child:  Image.network('https://cdn-icons-png.flaticon.com/512/2657/265793',
                              errorBuilder:(context,child,progress){
                                return progress == null  ? child :  SpinKitFadingCube(
                                  size: 30,
                                  color: defaultColor,
                                );
                              },
                              loadingBuilder:(context,child,progress){
                                return progress == null  ? child : SpinKitFadingCube(
                                  size: 30,
                                  color: defaultColor,
                                );
                              },
                            ),
                            radius: 10.w,
                            backgroundColor: Colors.grey[300],
                          ),
                          SizedBox(width: 5.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'مرحبا',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 13.sp),
                              ),
                              Text(
                                'mohamed swylam',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 13.sp),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      'السجل',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 13.sp),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'معلومات',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 13.sp),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      'معلومات عنا',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 55.h,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: cubit.kGooglePlex,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          onMapCreated: (GoogleMapController controller){
                            cubit.controllerGoogleMap.complete(controller);
                            cubit.newGoogleMapController = controller;
                          },
                        ),
                      ),
                      Positioned(
                        top: 13.0,
                        left: 13.0,
                        child: GestureDetector(
                          onTap: (){
                            scaffoldKey.currentState.openDrawer();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.menu,color: Colors.black,),
                              radius: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 4.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'مرحبا',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black, fontSize: 13.sp),
                              ),
                              Text(
                                'إلي اين ؟',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black, fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 8.h,
                          width: double.infinity,
                          child: Center(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              onTap: () {},
                              cursorHeight: 5,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),
                                hintText: 'ابحث عن وجهتك',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).splashColor),
                                fillColor: Colors.grey[300],
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(
                                      Feather.search,
                                      size: 5.w,
                                      color: defaultColor,
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'اضف منزلك',
                                  style: TextStyle(color: Colors.black, fontSize: 10.sp,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'عنوان اقامتك الحالي',
                                  style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(Feather.home,size: 8.w,),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'اضف عملك',
                                  style: TextStyle(color: Colors.black, fontSize: 10.sp,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'عنوان عملك الحالي',
                                  style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(Icons.work_outline,size: 8.w,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
