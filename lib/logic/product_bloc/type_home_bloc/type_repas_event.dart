part of 'type_repas_bloc.dart';

abstract class TypeRepasEvent extends Equatable {
  const TypeRepasEvent();

  @override
  List<Object> get props => [];
}

class FetchTypeRepas extends TypeRepasEvent {}
