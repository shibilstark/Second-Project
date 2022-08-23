part of 'conversation_cubit.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationSuccess extends ConversationState {
  ConverSationModel converSationModel;
  ConversationSuccess(this.converSationModel);
  @override
  List<Object> get props => [converSationModel];
}

class ConversationError extends ConversationState {}
