import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cards/data/repo/cards_repo.dart';
import 'delete_card_state.dart';

class DeleteCardCubit extends Cubit<DeleteCardState> {
  final CardsRepo _repository;

  DeleteCardCubit(this._repository) : super(DeleteCardInitial());

  Future<void> emitDeleteCard(String cardId) async {
    emit(DeleteCardLoading());
    try {
      await _repository.deleteCard(cardId);
      emit(DeleteCardSuccess());
    } catch (e) {
      emit(DeleteCardError(error: e.toString()));
    }
  }
}