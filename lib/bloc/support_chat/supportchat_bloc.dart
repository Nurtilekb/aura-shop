import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'supportchat_event.dart';
part 'supportchat_state.dart';

class SupportchatBloc extends Bloc<SupportchatEvent, SupportchatState> {
  SupportchatBloc() : super(SupportchatInitial()) {
    on<SupportchatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
