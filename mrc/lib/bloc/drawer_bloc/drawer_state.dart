part of 'drawer_bloc.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();
  
  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerClickedState extends DrawerState {
  // int index;
  // DrawerClickedState({required this.index});
}
class DrawerDashboardState extends DrawerState {
 
}
class DrawerMoniterState extends DrawerState {
 
}
class DrawerProfileState extends DrawerState {
 
}
class DrawerLogoutState extends DrawerState {
 
}
class DrawerIReportState extends DrawerState {
 
}
class DrawerPersonalizeState extends DrawerState {
 
}
class DrawerMapState extends DrawerState {
 
}
