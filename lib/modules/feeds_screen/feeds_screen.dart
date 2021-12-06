import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rider_app/layout/cubit/cubit.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:sizer/sizer.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      },
    );
  }
}

