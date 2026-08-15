import 'package:code_alpha_flash_card_app/features/cards/data/repo/cards_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cards/data/models/card_model.dart';
import 'edit_card_state.dart';

class EditCardCubit extends Cubit<EditCardState> {
  final CardsRepo _repository;

  EditCardCubit(this._repository) : super(EditCardInitial());

  Future<void> emitUpdateCard(CardModel card) async {
    emit(EditCardLoading());
    try {
      await _repository.updateCard(card);
      emit(EditCardSuccess());
    } catch (e) {
      emit(EditCardError(error: e.toString()));
    }
  }
}
