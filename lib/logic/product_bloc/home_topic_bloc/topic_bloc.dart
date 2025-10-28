import 'package:bloc/bloc.dart';
import 'package:diety/data/models/topic_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final ApiService _apiService = ApiService();

  TopicBloc() : super(TopicInitial()) {
    on<FetchTopics>((event, emit) async {
      emit(TopicLoadInProgress());
      try {
        final topics = await _apiService.getTopics();
        emit(TopicLoadSuccess(topics));
      } catch (e) {
        emit(TopicLoadFailure(e.toString()));
      }
    });
  }
}
