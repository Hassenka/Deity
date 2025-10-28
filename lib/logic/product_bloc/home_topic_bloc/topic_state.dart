part of 'topic_bloc.dart';

abstract class TopicState extends Equatable {
  const TopicState();

  @override
  List<Object> get props => [];
}

class TopicInitial extends TopicState {}

class TopicLoadInProgress extends TopicState {}

class TopicLoadSuccess extends TopicState {
  final List<Topic> topics;
  const TopicLoadSuccess(this.topics);
}

class TopicLoadFailure extends TopicState {
  final String error;
  const TopicLoadFailure(this.error);
}
