part of 'inter_mediat_cubit.dart';

abstract class InterMediatState extends Equatable {
  const InterMediatState();

  @override
  List<Object> get props => [];
}

class InterMediatInitial extends InterMediatState {}

class InterMediatSuccess extends InterMediatState {}
