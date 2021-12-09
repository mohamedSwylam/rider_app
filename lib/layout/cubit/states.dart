abstract class RiderAppStates {}

class RiderInitialState extends RiderAppStates {}

class RiderChangeBottomNavState extends RiderAppStates {}

class RiderChangeDropdownState extends RiderAppStates {}

class RiderAppBottomBarChangeState extends RiderAppStates {}

class RiderAppBottomBarSearchState extends RiderAppStates {}

class RiderAppBottomBarUserState extends RiderAppStates {}

class RiderAppBottomBarHomeState extends RiderAppStates {}

class RiderAppBottomBarCartState extends RiderAppStates {}

class RiderAppChangeThemeModeState extends RiderAppStates {}

class RiderAppChangeLanguageState extends RiderAppStates {}

class RiderAppGetLanguageState extends RiderAppStates {}

class RiderAppAddToCartSuccessState extends RiderAppStates {}

class RiderAppReduceCartItemByOneSuccessState extends RiderAppStates {}

class RiderAppClearCartSuccessState extends RiderAppStates {}

class RiderAppRemoveCartItemSuccessState extends RiderAppStates {}

class RiderAppClearWishListSuccessState extends RiderAppStates {}

class RiderAppRemoveWishListItemSuccessState extends RiderAppStates {}

class RiderAppAddItemToWishListSuccessState extends RiderAppStates {}

class RiderAppSearchQuerySuccessState extends RiderAppStates {}

class GetUserLoadingStates extends RiderAppStates {}

class GetUserSuccessStates extends RiderAppStates {}

class GetUserErrorStates extends RiderAppStates {}

class GetProductLoadingStates extends RiderAppStates {}

class GetProductSuccessStates extends RiderAppStates {}

class GetProductErrorStates extends RiderAppStates {}

class SignOutSuccessState extends RiderAppStates {}

//brandScreen
class SelectAddidasBrandState extends RiderAppStates {}

class SelectAppleBrandState extends RiderAppStates {}

class SelectDellBrandState extends RiderAppStates {}

class SelectHmBrandState extends RiderAppStates {}

class SelectNikeBrandState extends RiderAppStates {}

class SelectSamsungBrandState extends RiderAppStates {}

class SelectHuaweiBrandState extends RiderAppStates {}

class SelectAllBrandState extends RiderAppStates {}

class ChangeIndexState extends RiderAppStates {}

///////////uploadOrder
class CreateOrderSuccessState extends RiderAppStates {}

class CreateOrderErrorState extends RiderAppStates {}

class OnTapBrandItemState extends RiderAppStates {}

class OnTapBrandItemStatee extends RiderAppStates {}

////////////get order
class GetOrdersLoadingStates extends RiderAppStates {}

class GetOrdersSuccessStates extends RiderAppStates {}

class GetOrdersErrorStates extends RiderAppStates {}

//////////////////get banner
class GetBannersLoadingStates extends RiderAppStates {}

class GetBannersSuccessStates extends RiderAppStates {}

class GetBannersErrorStates extends RiderAppStates {
  final String error;

  GetBannersErrorStates(this.error);
}

/////////////////////////faceBook
class LoginWithFacebookLoadingStates extends RiderAppStates {}

class LoginWithFacebookSuccessStates extends RiderAppStates {}

////////////////
class GetCartsLoadingStates extends RiderAppStates {}

class GetCartsSuccessStates extends RiderAppStates {}

class GetCartsErrorStates extends RiderAppStates {
  final String error;

  GetCartsErrorStates(this.error);
}
/////////////////loginScreen

class LoginInitialState extends RiderAppStates {}

class LoginLoadingState extends RiderAppStates {}

class LoginSuccessState extends RiderAppStates {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends RiderAppStates {
  final String error;

  LoginErrorState(this.error);
}

class ForgetPasswordLoadingState extends RiderAppStates {}

class ForgetPasswordSuccessState extends RiderAppStates {}

class ForgetPasswordErrorState extends RiderAppStates {
  final String error;

  ForgetPasswordErrorState(this.error);
}

class LoginAnonymousLoadingState extends RiderAppStates {}

class LoginAnonymousSuccessState extends RiderAppStates {}

class LoginAnonymousErrorState extends RiderAppStates {
  final String error;

  LoginAnonymousErrorState(this.error);
}

class LoginWithFacebookLoadingState extends RiderAppStates {}

class LoginWithFacebookSuccessState extends RiderAppStates {}

class LoginWithFacebookErrorState extends RiderAppStates {
  final String error;

  LoginWithFacebookErrorState(this.error);
}

class LoginPasswordVisibilityState extends RiderAppStates {}

class LoginState extends RiderAppStates {}

class GetUserLoginLoadingStates extends RiderAppStates {}

class GetUserLoginSuccessStates extends RiderAppStates {}

class GetUserLoginErrorStates extends RiderAppStates {}

class CreateCartItemSuccessState extends RiderAppStates {}

class CreateCartItemErrorState extends RiderAppStates {}
////////////////////////////watchedRecently
class UploadWatchedItemSuccessState extends RiderAppStates {}

class UploadWatchedItemErrorState extends RiderAppStates {}

class GetWatchedLoadingStates extends RiderAppStates {}

class GetWatchedSuccessStates extends RiderAppStates {}

class GetWatchedErrorStates extends RiderAppStates {
  final String error;

  GetWatchedErrorStates(this.error);
}
class RemoveFromWatchedLoadingStates extends RiderAppStates {}

class RemoveFromWatchedSuccessStates extends RiderAppStates {}

class RemoveFromWatchedErrorStates extends RiderAppStates {}
//////////////////////////////
///////////wishlist
class UploadWishListItemSuccessState extends RiderAppStates {}

class UploadWishListItemErrorState extends RiderAppStates {}

class GetWishListLoadingStates extends RiderAppStates {}

class GetWishListSuccessStates extends RiderAppStates {}

class GetWishListErrorStates extends RiderAppStates {
  final String error;

  GetWishListErrorStates(this.error);
}
class RemoveFromWishListLoadingStates extends RiderAppStates {}

class RemoveFromWishListSuccessStates extends RiderAppStates {}

class RemoveFromWishListErrorStates extends RiderAppStates {}

class RemoveFromCartLoadingStates extends RiderAppStates {}

class RemoveFromCartSuccessStates extends RiderAppStates {}

class RemoveFromCartErrorStates extends RiderAppStates {}

class ClearCartLoadingStates extends RiderAppStates {}

class ClearCartSuccessStates extends RiderAppStates {}

class ClearCartErrorStates extends RiderAppStates {}

class AddCartItemByOneLoadingStates extends RiderAppStates {}

class AddCartItemByOneSuccessStates extends RiderAppStates {}

class AddCartItemByOneErrorStates extends RiderAppStates {}

class ReduceCartItemByOneLoadingStates extends RiderAppStates {}

class ReduceCartItemByOneSuccessStates extends RiderAppStates {}

class ReduceCartItemByOneErrorStates extends RiderAppStates {}

//updateprofile

class UpdateErrorState extends RiderAppStates {
  final String error;

  UpdateErrorState(this.error);
}
//Remove order
class RemoveOrderLoadingStates extends RiderAppStates {}

class RemoveOrderSuccessStates extends RiderAppStates {}

class RemoveOrderErrorStates extends RiderAppStates {}
////////////
class UpdateLoadingState extends RiderAppStates {}

/////signUp

class SignUpInitialState extends RiderAppStates {}

class SignUpLoadingState extends RiderAppStates {}

class SignUpSuccessState extends RiderAppStates {}

class SignUpErrorState extends RiderAppStates {
  final String error;

  SignUpErrorState(this.error);
}

class CreateUserSuccessState extends RiderAppStates {}

class CreateUserErrorState extends RiderAppStates {
  final String error;

  CreateUserErrorState(this.error);
}

class SignUpPasswordVisibilityState extends RiderAppStates {}

class SignUpPickedProfileImageSuccessState extends RiderAppStates {}

class SignUpPickedProfileImageErrorState extends RiderAppStates {}

class UploadProfileImageLoadingState extends RiderAppStates {}

class UploadPickedProfileImageSuccessState extends RiderAppStates {}

class UploadPickedProfileImageErrorState extends RiderAppStates {}

class SignUpPickedProfileImageCameraSuccessState extends RiderAppStates {}

class SignUpRemoveProfileImageSuccessState extends RiderAppStates {}

//////////write comment
class WriteCommentLoadingState extends RiderAppStates {}

class WriteCommentSuccessState extends RiderAppStates {}

class WriteCommentErrorState extends RiderAppStates {}

class GetCommentsLoadingStates extends RiderAppStates {}

class GetCommentsSuccessStates extends RiderAppStates {}

class GetCommentsErrorStates extends RiderAppStates {}

class ChangeRateSuccessStates extends RiderAppStates {}
//////////////////// notification
class PushNotificationLoadingState extends RiderAppStates {}
class PushNotificationSuccessState extends RiderAppStates {}
class PushNotificationErrorState extends RiderAppStates {}
//////////////phone
class CodeSentState extends RiderAppStates {}
class CodeAutoRetrievalTimeoutState extends RiderAppStates {}
class StartTimerState extends RiderAppStates {}
class SetDataState extends RiderAppStates {}
class OnPinCompletedState extends RiderAppStates {}
class PhoneSignInSuccessState extends RiderAppStates {
  final String uId;

  PhoneSignInSuccessState(this.uId);
}
class PhoneSignInErrorState extends RiderAppStates {
  final  error;

  PhoneSignInErrorState(this.error);
}
class PaddingOfMapState extends RiderAppStates {}
////////////////searchCoordinateAddress
class SearchCoordinateAddressLoadingState extends RiderAppStates {}
class SearchCoordinateAddressSuccessState extends RiderAppStates {}
class SearchCoordinateAddressErrorState extends RiderAppStates {}