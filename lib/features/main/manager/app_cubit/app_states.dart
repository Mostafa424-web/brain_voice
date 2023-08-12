abstract class AppState {}

class InitialState extends AppState {}
class LoadedJsonState extends AppState {}

class CheckValueInJsonState extends AppState {}
class EmptyArrayFromImages extends AppState {}

class LoadedImagesState extends AppState {}

class ScreensBottomNavStates extends AppState {}

class GetUserSuccess extends AppState {}
class GetUserError extends AppState {
  final String errorMessage;

  GetUserError(this.errorMessage);
}
class ChangeRememberMeState extends AppState {}
class ClickLoginState extends AppState {}
class ChangeLoadingState extends AppState {}
