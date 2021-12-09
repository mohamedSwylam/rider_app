import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider_app/assistant/assistant_methods.dart';
import 'package:rider_app/layout/cubit/states.dart';
import 'package:rider_app/models/user_model.dart';
import 'package:rider_app/modules/cart_screen/cart_screen.dart';
import 'package:rider_app/modules/feeds_screen/feeds_screen.dart';
import 'package:rider_app/modules/home_screen/home_screen.dart';
import 'package:rider_app/modules/landingPage/landing_page.dart';
import 'package:rider_app/modules/search/search_screen.dart';
import 'package:rider_app/modules/user_screen/user_screen.dart';
import 'package:rider_app/shared/components/components.dart';
import 'package:rider_app/shared/network/local/cache_helper.dart';
import 'package:rider_app/shared/network/remote/dio_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

import '../rider_layout.dart';

class RiderAppCubit extends Cubit<RiderAppStates> {
  RiderAppCubit() : super(RiderInitialState());

  static RiderAppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> RiderScreens = [
    HomeScreen(),
    FeedsScreen(),
    SearchScreen(),
    CartScreen(),
    UserScreen(),
  ];

  void selectedHome() {
    currentIndex = 0;
    emit(RiderAppBottomBarHomeState());
  }

  void selectedCart() {
    currentIndex = 3;
    emit(RiderAppBottomBarCartState());
  }

  void selectedSearch() {
    currentIndex = 2;
    emit(RiderAppBottomBarSearchState());
  }

  void selectedUser() {
    currentIndex = 4;
    emit(RiderAppBottomBarUserState());
  }

  bool isDark = false;

  void changeThemeMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(RiderAppChangeThemeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(RiderAppChangeThemeModeState());
      });
    }
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(RiderChangeBottomNavState());
  }

  ///////////////////////////SignUp
  void userSignUp({
    @required String password,
    @required String email,
    @required String name,
    @required String phone,
    @required String joinedAt,
    @required String createdAt,
    @required String profileImage,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        uId: value.user.uid,
        name: name,
        email: email,
        phone: phone,
        joinedAt: joinedAt,
        createdAt: createdAt,
        profileImage: profileImage,
      );
      print(value.user.email);
      print(value.user.uid);
      emit(SignUpSuccessState());
    }).catchError((error) {
      emit(SignUpErrorState(error.toString()));
    });
  }

  void createUser({
    String name,
    String uId,
    String phone,
    String email,
    String joinedAt,
    String createdAt,
    String profileImage,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: email,
      uId: uId,
      profileImage: profileImage,
      createdAt: createdAt,
      joinedAt: joinedAt,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  IconData prefix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    prefix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(SignUpPasswordVisibilityState());
  }

  File profile;
  String url;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profile = File(pickedFile.path);
      uploadProfileImage();
      emit(SignUpPickedProfileImageSuccessState());
    } else {
      print('No image selected.');
      emit(SignUpPickedProfileImageErrorState());
    }
  }

  void uploadProfileImage() {
    emit(UploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profile.path)
        .pathSegments
        .last}')
        .putFile(profile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        url = value;
        print(value);
        emit(UploadPickedProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadPickedProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadPickedProfileImageErrorState());
    });
  }

  void pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
    await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(profile.path);
    profile = pickedImageFile;
    uploadProfileImage();
    emit(SignUpPickedProfileImageCameraSuccessState());
  }

  void remove() {
    url =
    'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
    uploadProfileImage();
    emit(SignUpRemoveProfileImageSuccessState());
  }

  ///////////////////////////// login Screen
  void userLogin({
    @required String password,
    @required String email,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      getUserData();
      print(value.user.email);
      print(value.user.uid);
      emit(LoginSuccessState(value.user.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  void userForgetPassword({
    @required String email,
  }) {
    emit(ForgetPasswordLoadingState());
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.trim().toLowerCase())
        .then((value) {
      emit(ForgetPasswordSuccessState());
    }).catchError((error) {
      emit(ForgetPasswordErrorState(error.toString()));
    });
  }


  void updateUser({
    String name,
    String phone,
    String email,
    String uId,
    String profileImage,
    String address,
    String joinedAt,
    String createdAt,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: email,
      uId: uId,
      profileImage: profileImage,
      createdAt: createdAt,
      joinedAt: joinedAt,
    );
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'profileImage': profileImage,
      'joinedAt': joinedAt,
      'createdAt': createdAt,
      'address': address,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateErrorState(error.toString()));
    });
  }

/*  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(LoginPasswordVisibilityState());
  }*/

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name;
  String phone;
  String email;
  String uId;
  String profileImage;
  String address;
  String joinedAt;
  String createdAt;

  void getUserData() async {
    emit(GetUserLoginLoadingStates());
    User user = _auth.currentUser;
    uId = user.uid;
    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    final DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uId).get();
    if (userDoc == null) {
      return;
    } else {
      name = userDoc.get('name');
      email = user.email;
      joinedAt = userDoc.get('joinedAt');
      phone = userDoc.get('phone');
      address = userDoc.get('address');
      profileImage = userDoc.get('profileImage');
      createdAt = userDoc.get('createdAt');
      emit(GetUserLoginSuccessStates());
    }
  }

  Future<void> googleSignIn(context) async {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          createUser(
            uId: googleAccount.id,
            profileImage: googleAccount.photoUrl,
            phone: '',
            email: googleAccount.email,
            joinedAt: formattedDate,
            createdAt: Timestamp.now().toString(),
            name: googleAccount.email,
          );
          name = googleAccount.displayName;
          email = googleAccount.email;
          joinedAt = formattedDate;
          phone = '';
          address = '';
          profileImage = googleAccount.photoUrl;
          createdAt = Timestamp.now().toString();
          getUserData();
          CacheHelper.saveData(key: 'uId', value: googleAccount.id).then((
              value) {
            navigateAndFinish(context, RiderLayout());
          });
        } catch (error) {
          authErrorHandle(error.message, context);
        }
      }
    }
  }

  Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/564/564619.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error occured'),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  //////////////////////////facebook Login
  var loading = false;

  void logInWithFacebook(context) async {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    loading = true;
    emit(LoginWithFacebookLoadingStates());
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken.token);
      await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential)
          .then((value) {
        createUser(
          uId: value.user.uid,
          name: userData['name'],
          email: userData['email'],
          phone: '',
          joinedAt: formattedDate,
          createdAt: Timestamp.now().toString(),
          profileImage: userData['picture']['data']['url'],
        );
        getUserData();
        CacheHelper.saveData(key: 'uId', value: value.user.uid).then((value) {
          navigateAndFinish(context, RiderLayout());
        });
      });
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }

      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Log in with facebook failed'),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              ));
    } finally {
      loading = false;
      emit(LoginWithFacebookSuccessStates());
    }
  }

  ///////////////////////////////////Signout
  void signOut(context) =>
      CacheHelper.removeData(key: 'uId').then((value) {
        if (value) {
          FirebaseAuth.instance
              .signOut()
              .then((value) => navigateAndFinish(context, LandingPage()));
          emit(SignOutSuccessState());
        }
      });


////////////// languag
  bool isEn = true;
  Map<String, Object> textsAr = {
    "landing1": "مرحبا",
    "landing2": "مرحبا بك في كنده تشيز",
    "landing3": "دخول",
    "landing4": "انشاء حساب",
    "landing5": "او يمكنك استخدام",
    "landing6": "الدخول كزائر",
    "login1": "كنده تشيز",
    "login2": "البريد الالكتروني",
    "login3": "كلمه المرور",
    "login4": "نسيت كلمه المرور",
    "login5": "دخول",
    "login6": "كلمه المرور غير صالحه",
    "login7": "بريد الكتروني غير صالح",
    "forgetPass1": "كنده تشيز",
    "forgetPass2": "البريد الالكتروني",
    "forgetPass3": "اعاده تعيين",
    "forgetPass4": "بريد الكتروني غير صالح",
    "forgetPassDialog1": "'تم ارسال رابط اعاده تعيين كلمه المرور بنجاح",
    "forgetPassDialog2":
    "برجاء التوجه الي صندوق الوارد بالبريد الالكتروني الخاص بكم لاعاده تعيين كلمه المرور الخاصه بكم",
    "forgetPassDialog3": "موافق",
    "signUp1": "اختر",
    "signUp2": "الكاميرا",
    "signUp3": "المعرض",
    "signUp4": "حذف",
    "signUp5": "الاسم الذي ادخلته غير صالح",
    "signUp6": "ادخل اسمك",
    "signUp7": "بريد الكتروني غير صالح",
    "signUp8": "ادخل البريد الالكتروني",
    "signUp9": "رقم هاتف غير صالح",
    "signUp10": "ادخل رقم هاتفك",
    "signUp11": "عنوان غير صالح",
    "signUp12": "اكتب عنوان منزلك",
    "signUp13": "كلمه المرور غير صالحه",
    "signUp14": "ادخل كلمه المرور",
    "signUp15": "تسجيل",
    "cart1": "العربه",
    "cart2": "ج.م",
    "cart3": "  :  السعر",
    "cart4": "  :  السعر الكلي",
    "cart5": "  :  الكميه",
    "cart6": "تم تأكيد الطلب",
    "cart7": "تأكيد الطلب",
    "cart8": "الاتصال للطلب",
    "cart9": "حذف المنتج من العربه",
    "cart10": " هل تريد حقا حذف المنتج من العربه ",
    "cart11": " هل تريد حقا تنظيف العربه ",
    "cart12": "تنظيف العربه",
    "cartEmpty1": "سله المشتريات فارغه",
    "cartEmpty2": "يبدو انك لم تقم باضافه اي مشتريات حتي الان",
    "cartEmpty3": "تسوق الان",
    "wishListEmpty1": "المفضله فارغه",
    "wishListEmpty2": "يبدو انك لم تقم باضافه اي تفضيلات حتي الان",
    "orderEmpty1": "سله الطلبات فارغه",
    "orderEmpty2": "يبدو انك لم تقم باضافه اي طلبات حتي الان",
    "feeds": "جميع المنتجات",
    "feedsDia1": "في المفضلة",
    "feedsDia2": "اضف للمفضلة",
    "feedsDia3": "في العربه",
    "feedsDia4": "اضف للعربه",
    "feedsDia5": "فتح المنتج",
    "home1": "الرئيسية",
    "home2": "ابحث في المتجر",
    "home3": "الاصناف",
    "home4": "اشهر المنتجات",
    "home5": "توابل",
    "home6": "مجمدات",
    "home7": "مشروبات",
    "home8": "مثلجات",
    "home9": "جبن",
    "home10": "صوصات",
    "home11": "مخبوزات",
    "home12": "شيكولاته",
    "home13": "حلوي",
    "home14": "مكسرات",
    "home15": "بقاله",
    "home16": "شوهد موخرا",
    "orderDia1": "تم تاكيد طلبكم بنجاح",
    "orderDia2":
    "سوف يتم التواصل معكم في اقرب وقت ممكن للاستفسار بشان الطلب او المنتجات يمكنك الاتصال ويمكنكم ايضا مراجعه الطلب من سله الطلبات",
    "orderDia3": "موافق",
    "orderDetails1": "موافق",
    "orderDetails2": "تفاصيل الطلب",
    "orderDetails3": "تفاصيل التواصل",
    "orderDetails4": " : الاجمالي",
    "orderDetails5": " : الشحن",
    "orderDetails6": "العنوان الذي ادخلته غير صالح",
    "orderDetails7": "تفاصيل اكثر عن العنوان",
    "orderDetails8": "رقم الهاتف الذي ادخلته غير صالح",
    "orderDetails9": "رقم هاتف اخر للتواصل",
    "orderDetails10": "الاستفسار بشأن الطلب",
    "order1": "الطلبات",
    "order2": "جاري توصيل الطلب",
    "productDetails1": "تفاصيل المنتج",
    "productDetails2": "تقييم المنتج",
    "productDetails3": "بدون تقييم حتي الان",
    "productDetails4": "كن اول من يقيم",
    "productDetails5": "اضف تقييمك",
    "productDetails6": "قد يعجبك ايضا",
    "productDetails7": "اشتري الان",
    "productDetails8": "المنتج",
    "productReview1": "رائع",
    "productReview2": "ممتاز",
    "productReview3": "جيد",
    "productReview4": "لم يعجبني",
    "productReview5": "سئ",
    "productReview6": "اكتب تقييمك",
    "search1": "البحث",
    "search2": "ابحث في المتجر",
    "search3": "لا توجد نتائج",
    "user1": "ضيف",
    "user2": "حقيبه المستخدم",
    "user3": "المفضله",
    "user4": "العربه",
    "user5": "الطلبات",
    "user6": "معلومات المستخدم",
    "user7": "اسم المستخدم",
    "user8": "البريد الالكتروني",
    "user9": "رقم الهاتف",
    "user10": "عنوان المستخدم",
    "user11": "تاريخ الانضمام",
    "user12": "الاعدادات",
    "user13": "الوضع الليلي",
    "user14": "الانجليزيه",
    "user15": "تسجيل الخروج",
    "user16": "هل تريد حقا تسجيل الخروج",
    "dialog": "الغاء",
    "wishList1": "المفضله",
    "wishList2": "حذف من المفضله",
    "wishList3": "هل تريد حقا حذف المنتج المفضله",
    "backLayer1": "معلومات عنا",
    "backLayer2": "اشمون  ميدان فليفل خلف صيدليه الحكمه",
    "backLayer3": "ارقام التواصل",
    "backLayer4": "واتساب",
    "backLayer5": "فيسبوك",
    "backLayer6": "الموقع",
    "backLayer7": "العنوان",
    "backLayer8": "جروب كنده تشيز",
    "layout1": "الرئيسيه",
    "layout2": "المنتجات",
    "layout3": "البحث",
    "layout4": "العربه",
    "layout5": "المستخدم",
    "phone1": "التحقق من",
    "phone2": "اكتب 6 رموز للتأكيد",
    "orderDialog1": "تفاصيل الطلب",
    "orderDialog2": "اسم العميل",
    "orderDialog3": "عنوان العميل",
    "orderDialog4": "رقم تواصل",
    "orderDialog5": "المنتجات",
    "orderDialog6": "السعر الكلي",
    "orderDialog7": "الشحن",
    "orderDialog8": "الاجمالي",
    "orderDialog9": "الغاء الطلب",
    "orderDialog10": "الاستفسار بشان الطلب",
    "orderDialog11": "هل تريد حقا الغاء طلب الشراء",
  };
  Map<String, Object> textsEn = {
    "landing1": "Welcome",
    "landing2": "Welcome to kinda cheese",
    "landing3": "Login",
    "landing4": "Sign up",
    "landing5": "Or can use",
    "landing6": "As a gust",
    "login1": "Kinda Cheese",
    "login2": "Email address",
    "login3": "password",
    "login4": "Forget password",
    "login5": "Login",
    "login6": "Invalid password",
    "login7": "Invalid email address",
    "forgetPass1": "Kinda Cheese",
    "forgetPass2": "Email address",
    "forgetPass3": "Reset",
    "forgetPass4": "Invalid email address",
    "forgetPassDialog1": "Password reset link sent successfully",
    "forgetPassDialog2": "Please check your email inbox to reset your password",
    "forgetPassDialog3": "Ok",
    "signUp1": "Choose",
    "signUp2": "Camera",
    "signUp3": "Gallery",
    "signUp4": "Delete",
    "signUp5": "Invalid userName",
    "signUp6": "UserName",
    "signUp7": "Invalid email address",
    "signUp8": "Email address",
    "signUp9": "Invalid phone number",
    "signUp10": "Phone number",
    "signUp11": "Invalid address",
    "signUp12": "Home address",
    "signUp13": "Invalid password",
    "signUp14": "Password",
    "signUp15": "Sign Up",
    "cart1": "Cart",
    "cart2": "P",
    "cart3": "  :  Price",
    "cart4": "  :  Total Price",
    "cart5": "  :  Quantity",
    "cart6": "Order confirmed",
    "cart7": "Confirm order",
    "cart8": "Contact to order",
    "cart9": "Remove from cart",
    "cart10": "Do you want to remove the product from the cart",
    "cart11": " Do you want to remove all products from the cart ",
    "cart12": "Clear cart",
    "cartEmpty1": "Cart is empty",
    "cartEmpty2": "Looks like you haven't added anything to your cart yet",
    "cartEmpty3": "Shopping now",
    "wishListEmpty1": "WishList is empty",
    "wishListEmpty2":
    "Looks like you haven't added anything to your wishList yet",
    "orderEmpty1": "Order is empty",
    "orderEmpty2": "Looks like you haven't added anything to your orders yet",
    "feeds": " All Products",
    "feedsDia1": "In wishList",
    "feedsDia2": "Add to wish",
    "feedsDia3": "In cart",
    "feedsDia4": "Add to cart",
    "feedsDia5": "Open",
    "home1": "Home",
    "home2": "Search the Rider",
    "home3": "Categories",
    "home4": "Popular products",
    "home5": "Spices",
    "home6": "Freezers",
    "home7": "Drinks",
    "home8": "Ice cream",
    "home9": "Cheeses",
    "home10": "Sauces",
    "home11": "Bakery",
    "home12": "Chocolate",
    "home13": "Sweet",
    "home14": "Nuts",
    "home15": "Grocery",
    "home16": "Watched Recently",
    "orderDia1": "Your request has been successfully confirmed",
    "orderDia2":
    "We will contact you as soon as possible to inquire about the order or products You can call",
    "orderDia3": "ok",
    "orderDetails2": "Order Details",
    "orderDetails3": "Contact Details",
    "orderDetails4": "  :  Total ",
    "orderDetails5": "  :  Shipping",
    "orderDetails6": "The address you entered is not valid",
    "orderDetails7": "more details about the address",
    "orderDetails8": "The phone number you entered is invalid",
    "orderDetails9": "Another phone number to contact",
    "orderDetails10": "Order Inquiry",
    "order1": "Orders",
    "order2": "The order is being delivered",
    "productDetails1": "Product Details",
    "productDetails2": "Product Reviews",
    "productDetails3": "No Reviews yet.",
    "productDetails4": "Be the first to make review",
    "productDetails5": "Add review",
    "productDetails6": "You may also like",
    "productDetails7": "Buy now",
    "productDetails8": "Product",
    "productReview1": "Amazing",
    "productReview2": "Excellent",
    "productReview3": "good",
    "productReview4": "DisLike",
    "productReview5": "Bad",
    "productReview6": "Write your review",
    "search1": "Search",
    "search2": "Search the Rider",
    "search3": "No result found",
    "user1": "Gust",
    "user2": "User Bag",
    "user3": "WishList",
    "user4": "Cart",
    "user5": "Order",
    "user6": "User Information",
    "user7": "User Name",
    "user8": "Email address",
    "user9": "Phone number",
    "user10": "User address",
    "user11": "Join date",
    "user12": "Settings",
    "user13": "Dark Theme",
    "user14": "Arabic",
    "user15": "Log out",
    "user16": "Do you really want to log out",
    "dialog": "Cancel",
    "wishList1": "WishList",
    "wishList2": "Remove from wish",
    "wishList3": "Do you want to remove the product from the wishList",
    "backLayer1": "About Us",
    "backLayer2": "Ashmoun filyfal Square behined elhekma pharmacy",
    "backLayer3": "Contacts",
    "backLayer4": "WattsApp",
    "backLayer5": "FaceBook",
    "backLayer6": "Location",
    "backLayer7": "address",
    "backLayer8": "Kinda Cheese Group",
    "layout1": "Home",
    "layout2": "Products",
    "layout3": "Search",
    "layout4": "Cart",
    "layout5": "User",
    "phone1": "Verify",
    "phone2": "Enter 6 digit OTP",
    "orderDialog1": "Order details",
    "orderDialog2": "Customer name",
    "orderDialog3": "Customer address",
    "orderDialog4": "Customer phone",
    "orderDialog5": "Products",
    "orderDialog6": "Total",
    "orderDialog7": "Shipping",
    "orderDialog8": "Total Price",
    "orderDialog9": "Cancel order",
    "orderDialog10": "Inquiries about order",
    "orderDialog11": "Do you want to cancel order",
  };

  void changeLanguage({bool fromShared}) {
    if (fromShared != null) {
      isEn = fromShared;
      emit(RiderAppChangeLanguageState());
    } else {
      isEn = !isEn;
      CacheHelper.putBoolean(key: 'isEn', value: isEn).then((value) {
        emit(RiderAppChangeLanguageState());
      });
    }
  }

  getLan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isEn = prefs.getBool("isEn") ?? true;
    emit(RiderAppGetLanguageState());
  }

  Object getTexts(String txt) {
    if (isEn == true) return textsEn[txt];
    return textsAr[txt];
  }

  /////////phone authontication

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context,
      Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
      print(exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber({
    String verificationId,
    String smsCode,
    BuildContext context,
    @required String password,
    @required String name,
    @required String phone,
    @required String address,
    @required String joinedAt,
    @required String createdAt,
    @required String profileImage,
  }) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
      await _auth.signInWithCredential(credential).then((value) {
        createUser(
          profileImage: profileImage,
          uId: value.user.uid,
          phone: phone,
          name: name,
          email: '',
          joinedAt: joinedAt,
          createdAt: createdAt,
        );
        getUserData();
        showSnackBar(context, "logged In");
        emit(PhoneSignInSuccessState(value.user.uid));
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      emit(PhoneSignInErrorState(e.toString()));
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController mobilePhoneController = TextEditingController();
  String verificationIdFinal = "";
  String smsCode = "";

  void setData(String verificationId) {
    verificationIdFinal = verificationId;
    emit(SetDataState());
  }

  onPinCompleted(pin) {
    print("Completed: " + pin);
    smsCode = pin;
    emit(OnPinCompletedState());
  }

  /////////////google Map
  Completer<GoogleMapController> controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double bottomPaddingOfMap = 0.0;

  void createGoogleMap(GoogleMapController controller) {
    controllerGoogleMap.complete(controller);
    newGoogleMapController = controller;
    locatePosition();
    bottomPaddingOfMap = 45.h;
    emit(PaddingOfMapState());
  }

  /////////////current position
  Position currentPosition;
  var geoLocator = Geolocator();

   locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(
        target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    String address = await searchCoordinateAddress(position);
    print('ths is your address : ' + address);
    emit(PushNotificationSuccessState());
  }
  //////////////searchCoordinateAddress
  Future<String> searchCoordinateAddress(Position position) async {
    emit(SearchCoordinateAddressLoadingState());
    String placeAddress = "";
    DioHelper.getData(url: 'maps/api/geocode/json', query: {
      'latlng': '${position.latitude},${position.longitude}',
      'key': 'AIzaSyDPvjOaeiUePi5hxsOKa-_FhuzpEr_iLn0',
    }).then((value) {
      placeAddress = value.data['results'][0]['formatted_address'];
      print(value.data['results'][0]['formatted_address']);
      emit(SearchCoordinateAddressSuccessState());
      return placeAddress;
    }).catchError((error) {
      emit(SearchCoordinateAddressErrorState());
    });
  }
}

