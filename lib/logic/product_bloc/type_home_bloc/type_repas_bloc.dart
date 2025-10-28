import 'package:bloc/bloc.dart';
import 'package:diety/data/models/type_repas_model.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:equatable/equatable.dart';

part 'type_repas_event.dart';
part 'type_repas_state.dart';

class TypeRepasBloc extends Bloc<TypeRepasEvent, TypeRepasState> {
  final ApiService _apiService = ApiService();

  TypeRepasBloc() : super(TypeRepasInitial()) {
    on<FetchTypeRepas>((event, emit) async {
      emit(TypeRepasLoadInProgress());
      try {
        final items = await _apiService.getTypeRepas();
        emit(TypeRepasLoadSuccess(items));
      } catch (e) {
        emit(TypeRepasLoadFailure(e.toString()));
      }
    });
  }
}
