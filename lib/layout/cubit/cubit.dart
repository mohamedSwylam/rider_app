import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rider_app/layout/cubit/states.dart';

class AppCubit extends Cubit<AppStates>  {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);


}