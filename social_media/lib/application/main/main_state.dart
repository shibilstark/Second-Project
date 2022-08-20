part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainSuccess extends MainState {}

class MainError extends MainState {}
