part of 'supportchat_bloc.dart';

sealed class SupportchatState extends Equatable {
  const SupportchatState();
  
  @override
  List<Object> get props => [];
}

final class SupportchatInitial extends SupportchatState {}
