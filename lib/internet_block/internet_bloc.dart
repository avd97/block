import 'dart:async';

import 'package:block/internet_block/internet_event.dart';
import 'package:block/internet_block/internet_state.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState>{

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainerEvent>((event, emit) => emit(InternetGainedState()));

    connectionListen(result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        add(InternetGainerEvent());
      } else {
        add(InternetLostEvent());
      }
    }

    connectivitySubscription = _connectivity.onConnectivityChanged.listen(connectionListen);

  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}