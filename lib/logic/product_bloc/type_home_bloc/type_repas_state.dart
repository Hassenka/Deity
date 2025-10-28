part of 'type_repas_bloc.dart';

abstract class TypeRepasState extends Equatable {
  const TypeRepasState();

  @override
  List<Object> get props => [];
}

class TypeRepasInitial extends TypeRepasState {}

class TypeRepasLoadInProgress extends TypeRepasState {}

class TypeRepasLoadSuccess extends TypeRepasState {
  final List<TypeRepasItem> typeRepasItems;
  const TypeRepasLoadSuccess(this.typeRepasItems);
}

class TypeRepasLoadFailure extends TypeRepasState {
  final String error;
  const TypeRepasLoadFailure(this.error);
}
