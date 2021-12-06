import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:sizer/sizer.dart';



class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = RiderAppCubit.get(context);
    return BlocConsumer<RiderAppCubit, RiderAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Text(
                'cart Screen',
              ),
            ),
          );
        });
  }
}



