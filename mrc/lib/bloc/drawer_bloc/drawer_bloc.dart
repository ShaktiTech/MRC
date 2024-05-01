import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mrc/repository/user_repositories.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
   UserRepository userRepository;
  DrawerBloc({required this.userRepository}) : super(DrawerInitial()) {
    on<DrawerEvent>((event, emit) {
     if(event is DrawerListClicked)
     {
      print("Index SSS ${event.index}");
      if(event.index ==0)
      {
       emit(DrawerDashboardState());
      }
      else if(event.index == 1)
      {
        emit(DrawerMapState());
      }
       else if(event.index == 2)
      {
        emit(DrawerMoniterState());
      }
      else if(event.index == 3)
      {
        emit(DrawerPersonalizeState());
      }
      else if(event.index == 4)
      {
        emit(DrawerIReportState());
      }
     }
      if(event is DrawerProfileClicked)
     {
     
       emit(DrawerProfileState());
     
     }
       if(event is DrawerLogoutClicked)
     {
        print("SSS DrawerLogoutClicked 1");
      userRepository.signOut();
       emit(DrawerLogoutState());
     
     }
    });
  }
}
