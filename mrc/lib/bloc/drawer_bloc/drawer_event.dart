part of 'drawer_bloc.dart';

abstract class DrawerEvent extends Equatable {
  const DrawerEvent();

  @override
  List<Object> get props => [];
}
class DrawerListClicked extends DrawerEvent {
 int index;
  DrawerListClicked({required this.index});
}
class DrawerProfileClicked extends DrawerEvent {
 // String email, password;
  DrawerProfileClicked();
}
class DrawerLogoutClicked extends DrawerEvent {
 // String email, password;
  DrawerLogoutClicked();
}