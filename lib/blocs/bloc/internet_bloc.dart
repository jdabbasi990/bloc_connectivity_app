import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  // bloc initialization
  InternetBloc() : super(InternetInitialState()) {
    // events --> state emit
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));

    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));

    _connectivity.onConnectivityChanged.listen((result) {
      print('Connecvtivity result: $result');
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        print('Success Event triggered');
        add(InternetGainedEvent());
      } else {
        print('Failed Event triggered');

        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
