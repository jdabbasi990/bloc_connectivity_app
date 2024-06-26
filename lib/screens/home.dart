import 'package:bloc_connectivity_app/blocs/bloc/internet_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InternetBloc internetBloc = BlocProvider.of<InternetBloc>(context);
    print(internetBloc.state); // Print the initial state

    Future.delayed(Duration.zero, () async {
      final result = await Connectivity().checkConnectivity();
      print('Connectivity check result: $result');
    });

    return Scaffold(
      body: BlocConsumer<InternetBloc, InternetState>(
        listener: ((context, state) {
          // listener only listen not provide any widget only for background task
          if (state is InternetGainedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Internet Connected')),
            );
          } else if (state is InternetLostState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Internet not Connected')),
            );
          }
        }),
        builder: (context, state) {
          print('Received state: $state'); // This will print the current state

          if (state is InternetGainedState) {
            return Container(
              color: Colors.greenAccent,
              child: const Center(
                child: Text('Connected'),
              ),
            );
          } else if (state is InternetLostState) {
            return Container(
              color: Colors.redAccent[100],
              child: const Center(
                child: Text('Not Connected'),
              ),
            );
          } else {
            return Container(
              color: Colors.blueAccent,
              child: const Center(
                child: Text('Loading...'),
              ),
            );
          }
        },
      ),
    );
  }
}
